require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    context 'with authentication' do
      context 'with valid input' do

        let(:user) { Fabricate(:user) }
        let(:video) { Fabricate(:video) }  
        
        before do
          session[:user_id] = user.id
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end
        
        it 'should sets @video' do
          expect(Video.first).to eq(video)
        end

        it 'should set association with current_user' do
          expect(Review.first.user).to eq(user)
        end

        it 'should create review' do
          expect(Review.count).to eq(1)
        end
        
        it 'should redirect to @video' do
          expect(response).to redirect_to video
        end
      end

      context 'with invalid input' do

        let(:user) { Fabricate(:user) }
        let(:video) { Fabricate(:video) }  
        
        before do
          session[:user_id] = user.id
        end

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

    context 'without authentication' do
      
      let(:video) { Fabricate(:video) }            
      it 'should redirect to root_path' do
        session[:user_id] = nil

        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end
end
