
Fabricator(:time_slot) do
  start  DateTime.parse('10:00')
  finish { |slot| slot.start + 1.hour }
end