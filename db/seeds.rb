# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
seeds = []

# Warrior
seeds << { text: "You need a warrior spirit and an unbreakable will.", personality: :warrior, position: 1 }
seeds << { text: "You don’t win by being safe — you win by refusing to break.", personality: :warrior, position: 2 }
seeds << { text: "My strength comes from what I’ve survived.", personality: :warrior, position: 3 }
seeds << { text: "Resilience is my sharpest weapon.", personality: :warrior, position: 4 }
seeds << { text: "I can take punishment and turn it into power.", personality: :warrior, position: 5 }
seeds << { text: "I don’t fight for points. I fight to end it.", personality: :warrior, position: 6 }

# Athlete
seeds << { text: "Winning requires discipline, precision, and a plan.", personality: :athlete, position: 7 }
seeds << { text: "I out-train and out-prepare my opponents.", personality: :athlete, position: 8 }
seeds << { text: "Systems win wars. Clean technique wins rounds.", personality: :athlete, position: 9 }
seeds << { text: "I train to execute a game plan, not just react.", personality: :athlete, position: 10 }
seeds << { text: "I don’t get lucky — I get ready.", personality: :athlete, position: 11 }
seeds << { text: "Preparation creates calm. Calm creates control.", personality: :athlete, position: 12 }

# Artist
seeds << { text: "Winning requires adaptability and creativity.", personality: :artist, position: 13 }
seeds << { text: "Predictable is beatable — I stay unpredictable.", personality: :artist, position: 14 }
seeds << { text: "Experimentation and creative challenges make combat interesting.", personality: :artist, position: 15 }
seeds << { text: "Good movement is a magic trick where they don't see what's coming.", personality: :artist, position: 16 }
seeds << { text: "Everyone learns the same moves. Not everyone makes them their own.", personality: :artist, position: 17 }
seeds << { text: "I read the other person and create what comes next.", personality: :artist, position: 18 }

seeds.each do |s|
  mapping = { warrior: 0, athlete: 1, artist: 2 }
  Question.find_or_create_by!(position: s[:position]) do |q|
    q.text = s[:text]
    q.personality = mapping[s[:personality]]
  end
end
#   end
