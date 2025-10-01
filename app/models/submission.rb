class Submission < ApplicationRecord
  has_many :responses, dependent: :destroy

  def compute_results!
    scores = { "warrior" => 0, "athlete" => 0, "artist" => 0 }
    responses.includes(:question).each do |r|
      next unless r.question
      p_name = r.question.personality_name
      scores[p_name] += r.value.to_i
    end

    # Compute percentages based on overall max (36) per your spec
    percentages = scores.transform_values { |v| ((v.to_f / 36.0) * 100).round(1) }

    # Determine primary: allow ties to return combined label
    max_val = percentages.values.max
    top = percentages.select { |_k, v| v == max_val }.keys
    primary = top.length > 1 ? top.sort.join("-") : top.first

    update!(result_primary: primary, result_payload: { scores: scores, percentages: percentages }, completed_at: Time.current)

    { scores: scores, percentages: percentages, primary: primary }
  end

  PERSONALITY_DESCRIPTIONS = {
    "warrior" => <<~WAR.strip,
      You’re a Warrior

      You have a warrior spirit and an unbreakable will. You don’t just show up for the fight — you become the fight. When others fold, you rise. When you're hurt, you don’t slow down — you get sharper. Pain doesn’t break you; it builds you.

      You’ve been through things that taught you never to be weak, never to be taken advantage of, and never to back down. Your energy doesn’t drain when you’re down — it surges. That’s your edge.

      You are fueled by resolve, sharpened by adversity, and carried by a refusal to quit. You don't just fight to survive. You fight to finish.
    WAR
    "athlete" => <<~ATH.strip,
      The Athlete

      You’re a student of the game — calm under pressure, exact in movement, and relentless in preparation. You value precision, accuracy, and repeatable results. You don’t just train hard — you train smart, using discipline, data, and experience to build technical mastery. You create a game plan and execute it with intention and control.

      You’ve developed a high level of physical intelligence through focused, consistent work. You likely draw from a wide range of athletic experience and have a deep understanding of mechanics, timing, and strategy. While others rely on emotion or instinct, you rely on structure, clarity, and sharpened skill.

      You work.
    ATH
    "artist" => <<~ART.strip
      You don’t just fight — you create. For you, combat isn’t just about winning. It’s about how you win. You move differently, think differently, and constantly adapt. You don’t show up with a script — you build the fight in real time based on what you see, feel, and read in your opponent.

      You’re drawn to the creativity within chaos. While others repeat what they’ve been taught, you experiment. You find openings where others don’t. You use movement like a magic trick — not to show off, but to surprise, confuse, and ultimately break through.

      You express who you are through how you fight. For you, it’s not just about technique. It’s about timing, deception, and that moment when everything clicks and you make something new.
    ART
  }.freeze

  def description_for(personality_key)
    return "" unless personality_key
    key = personality_key.to_s
    # If it's a tie like 'artist-warrior', prefer the first personality's description
    primary_key = key.include?("-") ? key.split("-").first : key
    PERSONALITY_DESCRIPTIONS[primary_key] || ""
  end
end
