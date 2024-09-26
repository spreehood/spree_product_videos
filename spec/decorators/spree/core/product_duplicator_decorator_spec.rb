require 'spec_helper'

RSpec.describe Spree::Core::ProductDuplicatorDecorator do
  let(:product) { create(:product) }
  let(:duplicator) { Spree::ProductDuplicator.new(product) }

  before do
    Spree::ProductDuplicator.prepend(Spree::Core::ProductDuplicatorDecorator)
  end

  describe '#duplicate' do
    context 'when the product has videos with tags' do
      let!(:video1) { create(:video, product: product) }
      let!(:video2) { create(:video, product: product) }
      let!(:tag1) { create(:product_video_tag) }
      let!(:tag2) { create(:product_video_tag) }

      before do
        video1.tags << tag1
        video2.tags << [tag1, tag2]
      end

      it 'duplicates the product with its videos and tags' do
        expect {
          @new_product = duplicator.duplicate
        }.to change(Spree::Product, :count).by(1)
          .and change(Spree::Video, :count).by(2)

        expect(@new_product.videos.count).to eq(2)
        expect(@new_product.videos.flat_map(&:tags).map(&:id)).to match_array([tag1.id, tag1.id, tag2.id])
      end

      it 'performs the duplication within a transaction' do
        allow(ActiveRecord::Base).to receive(:transaction).and_call_original
        duplicator.duplicate
        expect(ActiveRecord::Base).to have_received(:transaction)
      end

      it 'uses bulk insert for efficiency' do
        allow(Spree::Video).to receive(:import).and_call_original
        duplicator.duplicate
        expect(Spree::Video).to have_received(:import).once
      end
    end

    context 'when the product has videos without tags' do
      let!(:video_without_tags) { create(:video, product: product) }

      it 'duplicates the product with its videos, even if they have no tags' do
        expect {
          @new_product = duplicator.duplicate
        }.to change(Spree::Product, :count).by(1)
          .and change(Spree::Video, :count).by(1)

        expect(@new_product.videos.count).to eq(1)
        expect(@new_product.videos.first.tags).to be_empty
      end
    end

    context 'when the product has a mix of videos with and without tags' do
      let!(:video_with_tags) { create(:video, product: product) }
      let!(:video_without_tags) { create(:video, product: product) }
      let!(:tag) { create(:product_video_tag) }

      before do
        video_with_tags.tags << tag
      end

      it 'duplicates all videos correctly, preserving tag associations where they exist' do
        expect {
          @new_product = duplicator.duplicate
        }.to change(Spree::Product, :count).by(1)
          .and change(Spree::Video, :count).by(2)

        expect(@new_product.videos.count).to eq(2)
        expect(@new_product.videos.map { |v| v.tags.count }).to match_array([1, 0])
      end
    end

    context 'when the product has no videos' do
      it 'duplicates the product without creating new videos' do
        expect {
          @new_product = duplicator.duplicate
        }.to change(Spree::Product, :count).by(1)
          .and not_change(Spree::Video, :count)

        expect(@new_product.videos).to be_empty
      end
    end

    context 'when duplicating a product with a large number of videos and tags' do
      let!(:videos) { create_list(:video, 100, product: product) }
      let!(:tags) { create_list(:product_video_tag, 50) }

      before do
        videos.each do |video|
          video.tags << tags.sample(10)  # Assign 10 random tags to each video
        end
      end

      it 'successfully duplicates all videos and their tags' do
        expect {
          @new_product = duplicator.duplicate
        }.to change(Spree::Product, :count).by(1)
          .and change(Spree::Video, :count).by(100)

        expect(@new_product.videos.count).to eq(100)
        expect(@new_product.videos.flat_map(&:tags).map(&:id).uniq.count).to be_between(1, 50)
      end

      it 'completes the duplication within a reasonable time' do
        expect {
          Timeout.timeout(30) { @new_product = duplicator.duplicate }
        }.not_to raise_error
      end
    end

    context 'when duplicating a product with invalid video data' do
      let!(:valid_video) { create(:video, product: product) }
      let!(:invalid_video) { product.videos.build }  # An invalid video without necessary attributes

      it 'rolls back the transaction if any video is invalid' do
        expect {
          duplicator.duplicate
        }.to raise_error(ActiveRecord::RecordInvalid)
          .and change(Spree::Product, :count).by(0)
          .and change(Spree::Video, :count).by(0)
      end
    end

    context 'when duplicating a product with videos having special characters in tags' do
      let!(:video) { create(:video, product: product) }
      let!(:special_tag) { create(:product_video_tag, name: "Special & Char #Tag!") }

      before do
        video.tags << special_tag
      end

      it 'correctly duplicates videos with special character tags' do
        new_product = duplicator.duplicate
        expect(new_product.videos.first.tags.first.name).to eq("Special & Char #Tag!")
      end
    end
  end

  # Helper methods to create factories
  def self.create_video_factory
    FactoryBot.define do
      factory :video, class: 'Spree::Video' do
        association :product, factory: :product
        sequence(:title) { |n| "Video #{n}" }
        # Add other necessary attributes for a valid video
      end
    end
  end

  def self.create_product_video_tag_factory
    FactoryBot.define do
      factory :product_video_tag, class: 'Spree::ProductVideoTag' do
        sequence(:name) { |n| "Tag #{n}" }
      end
    end
  end

  # Create factories if they don't exist
  create_video_factory
  create_product_video_tag_factory
end