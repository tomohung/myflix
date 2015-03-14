require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    context 'with authentication' do
      context 'with valid input' do

        let(:video) { Fabricate(:video) }  
        
        before do
          set_current_user
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end
        
        it 'should sets @video' do
          expect(Video.first).to eq(video)
        end

        it 'should set association with current_user' do
          expect(Review.first.user).to eq(current_user)
        end

        it 'should create review' do
          expect(Review.count).to eq(1)
        end
        
        it 'should redirect to @video' do
          expect(response).to redirect_to video
        end
      end

      context 'with invalid input' do

        let(:video) { Fabricate(:video) }  
        
        before { set_current_user }

        it 'should not create review if rating is blank' do
          post :create, review: {context: Faker::Lorem::paragraph }, video_id: video.id
          expect(response).to render_template('videos/show')
        end
        
        it 'should not create review if context is blank' do
          post :create, review: {rating: (1..5).to_a.sample }, video_id: video.id
          expect(response).to render_template('videos/show')
        end

        it 'sets @video' do
          post :create, review: {rating: (1..5).to_a.sample }, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end

        it 'sets @reviews' do
          review = Fabricate(:review, video: video)
          post :create, review: {rating: (1..5).to_a.sample }, video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

    it_behaves_like 'require_sign_in' do
      let(:action) { post :create, review: Fabricate.attributes_for(:review), video_id: Fabricate(:video).id }
    end
  end
end
