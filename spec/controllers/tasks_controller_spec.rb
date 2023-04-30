require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:valid_params) {
    {
      description: "Fazer compras",
      date: Time.zone.now,
      done: true
    }
  }

  let(:invalid_params) {
    {
      description: "",
      date: Time.zone.now,
      done: nil
    }
  }

  describe "#create" do
    describe 'create a task' do
      context 'when task params is correctly' do

        it 'create a task' do
          post :create, params: valid_params

          expect(Task.count).to eq(1)
        end
      end

      context 'when task params is invalid' do
        it 'not create task' do
          delete :create, params: invalid_params

          expect(Task.count).to eq(0)
        end
      end
    end

    describe 'create a subtask' do
      context 'when subtask params is correctly' do
        let(:task) { create(:task) }

        let(:params) {
          {
            **valid_params,
            parent_id: task.id
          }
        }

        it 'create a subtask' do
          post :create, params: params

          expect(Task.count).to eq(2)
        end
      end
    end
  end

  describe "#update" do
    context 'when task params is correctly' do
      let(:task) { create(:task) }

      let(:params) {
        {
          id: task.id,
          **valid_params
        }
      }

      it 'update a task' do
        put :update, params: params

        task.reload
        expect(task.description).to eq(valid_params[:description])
        expect(task.done).to eq(true)
      end
    end

    context 'when task params is invalid' do
      let(:task) { create(:task) }

      let(:params) {
        {
          id: task.id,
          **invalid_params
        }
      }

      it 'does not a update task' do
        put :update, params: params

        task.reload
        expect(task.description).to eq(task.description)
        expect(task.done).to eq(false)
      end
    end
  end

  describe "#destroy" do
    let(:task) { create(:task) }

    let(:params) {
      {
        id: task.id
      }
    }

    it 'destroy a task' do
      delete :destroy, params: params

      expect(Task.count).to eq(0)
    end
  end
end
