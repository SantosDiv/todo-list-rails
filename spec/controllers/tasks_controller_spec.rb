require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe "#create" do
    context 'when task params is correctly' do
      let(:params) {
        {
          task: {
            description: "Fazer compras",
            date: Time.zone.now
          }
        }
      }

      it 'create a task and return status 201' do
        post :create, params: params

        expect(Task.all.count).to eq(1)
        expect(response.status).to eq(201)
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

      it 'not create task and return status 400' do
        delete :create, params: params

        expect(Task.all.count).to eq(0)
        expect(response.status).to eq(400)
      end
    end
  end

  describe "#update" do
    context 'when task params is correctly' do
      let(:task) { create(:task) }
      let(:description) { "Fazer compras" }

      let(:params) {
        {
          id: task.id,
          task: {
            description: description,
            date: Time.zone.now,
            done: true
          }
        }
      }

      it 'create a task and return status 201' do
        put :update, params: params
        task = Task.last
        expect(task.description).to eq(description)
        expect(task.done).to eq(true)
        expect(response.status).to eq(201)
      end
    end
  end
end
