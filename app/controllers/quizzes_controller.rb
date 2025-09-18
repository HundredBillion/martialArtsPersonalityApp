class QuizzesController < ApplicationController
  before_action :set_submission, only: [:question, :respond, :result, :reset]

  def index
    # intro / start page
  end

  # Create a fresh submission and store id in session, then redirect to first question
  def start
    @submission = Submission.create!
    session[:submission_id] = @submission.id
    redirect_to quiz_question_path(pos: 1)
  end

  # Render a single question for the given position
  def question
    pos = (params[:pos] || 1).to_i
    @question = Question.find_by(position: pos)
    if @question.nil?
      redirect_to quiz_result_path and return
    end

    render 'question', layout: 'application'
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

    # Next question or results
    next_q = Question.find_by(position: question.position + 1)
    if next_q
      redirect_to quiz_question_path(pos: next_q.position)
    else
      @submission.compute_results!
      redirect_to quiz_result_path
    end
  end

  # Show final result page
  def result
    @submission = Submission.find_by(id: session[:submission_id])
    unless @submission
      redirect_to root_path, alert: 'No active quiz found. Start a new quiz.' and return
    end
    @submission.compute_results! unless @submission.result_payload.present?
    render 'result', layout: 'application'
  end

  # Reset current quiz: create a fresh submission and store id in session
  def reset
    if session[:submission_id]
      cur = Submission.find_by(id: session[:submission_id])
      cur.responses.destroy_all if cur
    end
    new_sub = Submission.create!
    session[:submission_id] = new_sub.id
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
end
