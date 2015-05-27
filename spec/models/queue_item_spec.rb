require 'rails_helper'

describe QueueItem do
  it { should belong_to (:video)}
  it { should belong_to (:user)}
end