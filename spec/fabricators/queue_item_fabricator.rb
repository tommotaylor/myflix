Fabricator(:queue_item) do
  list_order { rand(1..10) }
end