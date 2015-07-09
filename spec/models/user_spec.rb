require 'rails_helper'

describe User do
  
  it { should have_many(:queue_items).order(:list_order) }

end
