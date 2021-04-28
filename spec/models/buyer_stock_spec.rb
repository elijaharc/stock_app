require 'rails_helper'

RSpec.describe Buyer, type: :model do
  describe 'check_db' do
    context 'when stock has not yet been bought by buyer' do
      let!(:buyer) { FactoryBot.create(:buyer) }
      let!(:stock) { FactoryBot.create(:stock) }

      it "returns 'nil'" do
        expect(BuyerStock.check_db(stock.id, buyer.id)).to be_nil
      end
    end

    context 'when stock has already been bought by buyer' do
      let!(:buyer) { FactoryBot.create(:buyer) }
      let!(:stock) { FactoryBot.create(:stock) }

      it 'returns the stock object' do
        buyer.stocks << stock
        expect(BuyerStock.check_db(stock.id, buyer.id)).to be_a_kind_of Object
      end
    end
  end
end
