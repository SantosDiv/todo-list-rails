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
    describe 'create a parent task' do
      context 'when task params is correctly' do

        it 'create with success' do
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

  describe "#change_status" do
    let(:task) { create(:task) }

    context 'when is parent task' do
      let(:params) {
        {
          task_id: task.id
        }
      }

      it 'change status successfully' do
        put :change_status, params: params

        task.reload
        expect(task.done).to eq(true)
      end

      context 'and has a subtasks' do
        let(:parent_task) { create(:task, :with_two_sub_tasks) }

        let(:params) {
          {
            task_id: parent_task.id
          }
        }

        it 'change parent status and all subtasks status' do
          put :change_status, params: params

          parent_task.reload
          subtasks = parent_task.sub_tasks

          expect(parent_task.done).to eq(true)
          expect(subtasks.first.done).to eq(parent_task.done)
          expect(subtasks.second.done).to eq(parent_task.done)
        end
      end
    end

    context 'when is subtasks' do
      let(:task) { create(:task, :with_two_sub_tasks) }
      let(:sub_task) { task.sub_tasks.first }

      context 'and not all tasks were completed' do
        let(:params) {
          {
            task_id: sub_task.id
          }
        }

        it 'change status only subtask' do
          put :change_status, params: params

          sub_task.reload
          expect(sub_task.done).to eq(true)
          expect(task.done).to eq(false)
        end
      end

      context 'and all tasks were completed' do
        let(:task) { create(:task, :with_at_least_one_completed_subtask) }
        let(:sub_task) { task.sub_tasks.last }
        let(:params) {
          {
            task_id: sub_task.id
          }
        }

        it 'change status subtask and parent task' do
          put :change_status, params: params

          sub_task.reload
          task.reload
          expect(sub_task.done).to eq(true)
          expect(task.done).to eq(true)
        end
      end

    end
  end
end
