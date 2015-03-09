require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    context 'with authentication' do
      let(:reivew) { Fabricate(:review) }

      it 'should assign rating'
      it 'should assign context'
      it 'should create review'
      it 'should redirect to back'

    end

    context 'without authentication' do
      it 'should not create review'
      it 'should redirect to back'
    end

  end

end