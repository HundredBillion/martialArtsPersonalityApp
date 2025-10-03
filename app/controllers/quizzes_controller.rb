class QuizzesController < ApplicationController
  before_action :set_submission, only: [ :question, :respond, :result, :reset ]

  def index
    # intro / start page
  end

  # Create a fresh submission and store id in session, then redirect to first question
  def start
    @submission = Submission.create!
    session[:submission_id] = @submission.id
    # Clear any existing randomized question order for fresh start
    session[:randomized_question_ids] = nil
    redirect_to quiz_question_path(pos: 1)
  end

  # Render a single question for the given position
  def question
    pos = (params[:pos] || 1).to_i

    # Get or create randomized question order for this submission
    randomized_questions = get_randomized_question_order

    # Check if we've reached the end of questions
    if pos > randomized_questions.length
      redirect_to quiz_result_path and return
    end

    # Get the question at this position in the randomized order
    question_id = randomized_questions[pos - 1] # pos is 1-indexed, array is 0-indexed
    @question = Question.find_by(id: question_id)

    if @question.nil?
      redirect_to quiz_result_path and return
    end

    render "question", layout: "application"
  end

  # Accept an answer and show next question or results
  def respond
    value = params[:value].to_i
    qid = params[:question_id].to_i

    unless @submission
      @submission = Submission.create!
      session[:submission_id] = @submission.id
    end

    question = Question.find_by(id: qid)
    # Avoid duplicate responses for same question in this submission
    resp = @submission.responses.find_by(question_id: question.id)
    if resp
      resp.update!(value: value)
    else
      @submission.responses.create!(question: question, value: value)
    end

    # Get current position in randomized sequence and move to next
    randomized_questions = get_randomized_question_order
    current_index = randomized_questions.index(question.id)

    if current_index && current_index < randomized_questions.length - 1
      # Move to next question in randomized sequence
      next_pos = current_index + 2 # +2 because pos is 1-indexed
      redirect_to quiz_question_path(pos: next_pos)
    else
      # We've reached the end of questions
      @submission.compute_results!
      redirect_to quiz_result_path
    end
  end

  # Show final result page
  def result
    @submission = Submission.find_by(id: session[:submission_id])
    unless @submission
      redirect_to root_path, alert: "No active quiz found. Start a new quiz." and return
    end
    @submission.compute_results! unless @submission.result_payload.present?
    
    # Set up common variables
    @safe_results = @submission.result_payload || {}
    @percentages = @safe_results[:percentages] || @safe_results['percentages'] || {}
    @sorted_traits = ['warrior','athlete','artist'].sort_by { |p| -@percentages[p].to_f }
    
    # Set up trait variables
    @primary_trait = @sorted_traits[0]
    @secondary_trait = @sorted_traits[1]
    @tertiary_trait = @sorted_traits[2]
    
    # Determine current trait to display (from URL param or default to primary)
    @current_trait = params[:trait].present? ? params[:trait] : @primary_trait
    @trait_rank = @sorted_traits.index(@current_trait)
    
    render "result", layout: "application"
  end

  # Reset current quiz: create a fresh submission and store id in session
  def reset
    if session[:submission_id]
      cur = Submission.find_by(id: session[:submission_id])
      cur.responses.destroy_all if cur
    end
    new_sub = Submission.create!
    session[:submission_id] = new_sub.id
    # Clear the randomized question order to get a new random sequence
    session[:randomized_question_ids] = nil
    redirect_to quiz_question_path(pos: 1)
  end

  private

  def set_submission
    if session[:submission_id]
      @submission = Submission.find_by(id: session[:submission_id])
    end
    unless @submission
      @submission = Submission.create!
      session[:submission_id] = @submission.id
    end
  end

  def get_randomized_question_order
    # Store randomized question order in session to maintain consistency
    unless session[:randomized_question_ids]
      all_question_ids = Question.pluck(:id)
      session[:randomized_question_ids] = all_question_ids.shuffle
    end
    session[:randomized_question_ids]
  end
end
