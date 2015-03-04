require 'spec_helper'

describe Video do

  it { should belong_to(:category)}
  it { should validate_presence_of(:title, :description)}

end