require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe "#create" do
    context 'when task params is correctly' do
      let(:params) {
        {
          task: {
            description: "Fazer compras",
            date: Time.zone.now,
            done: true
          }
        }
      }

      it 'return status 200' do
        post :create, params: params

        expect(response.status).to eq(200)
      end
    end

    context 'when task params is invalid' do
      let(:params) {
        {
          task: {
            description: "",
            date: Time.zone.now,
            done: nil
          }
        }
      }

      it 'return status 400' do
        delete :create, params: params

        expect(response.status).to eq(400)
      end
    end
  end
end
