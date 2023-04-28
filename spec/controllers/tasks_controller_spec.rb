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

        expect(Task.count).to eq(1)
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

        expect(Task.count).to eq(0)
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

      it 'update a task and return status 200' do
        put :update, params: params

        task.reload
        expect(response.status).to eq(200)
        expect(task.description).to eq(description)
        expect(task.done).to eq(true)
      end
    end

    context 'when task params is invalid' do
      let(:task) { create(:task) }
      let(:description) { "" }

      let(:params) {
        {
          id: task.id,
          task: {
            description: description,
            date: Time.zone.now,
            done: nil
          }
        }
      }

      it 'does not a update task and return status 400' do
        put :update, params: params

        task.reload
        expect(task.description).to eq(task.description)
        expect(task.done).to eq(false)
        expect(response.status).to eq(400)
      end
    end
  end

  describe "#destroy" do
    context 'when task params is correctly' do
      let(:task) { create(:task) }

      let(:params) {
        {
          id: task.id
        }
      }

      it 'destroy a task and return status 200' do
        delete :destroy, params: params

        expect(response.status).to eq(200)
        expect(Task.count).to eq(0)
      end
    end

    context 'when task does not exist' do
      let(:params) {
        {
          id: "9999999"
        }
      }

      it 'return status 400' do
        delete :destroy, params: params

        expect(response.status).to eq(400)
      end
    end
  end
end
