require 'rails_helper'

describe UpdateTask do
  describe "#execute" do
    let(:task) { create(:task) }
    context "when params is invalid" do
      let(:invalid_task_params) {
        {
          id: task.id,
          descripion: nil
        }
      }

      let(:uc) { described_class }

      it 'raise error TaskException' do
        expect{ uc.new(task_params: invalid_task_params) }.to raise_error(TaskException)
      end

      context 'the subtask date is different from the original task' do
        let(:parent_task) { create(:task, :with_sub_task) }

        let(:subtask) { parent_task.sub_tasks }
        let(:params) {
          {
            id: subtask.first.id,
            descripion: "My Description",
            date: parent_task.date + 1.day
          }
        }

        it 'raise error TaskException' do
          expect{ uc.new(task_params: params) }.to raise_error(TaskException)
        end
      end
    end

    context "when params is valid" do
      let(:valid_task_params) {
        {
          id: task.id,
          description: "New description"
        }
      }

      let(:uc) { described_class }

      it 'build class successfully' do
        expect(uc.new(task_params: valid_task_params)).to be_instance_of(UpdateTask)
      end

      context "and it is a parent task and has no subtasks" do
        let(:params) {
          {
            date: task.date,
            **valid_task_params
          }
        }

        it 'update the task successfully' do
          task_updated = uc.new(task_params: params).execute(task_model: task)

          expect(task_updated.description).to eq(valid_task_params[:description])
        end
      end

      context "and it is a parent task and has subtasks" do
        let(:parent_task) { create(:task, :with_sub_task) }
        let(:subtask) { parent_task.sub_tasks.first }

        let(:params) {
          {
            date: Time.zone.now,
            **valid_task_params
          }
        }

        it 'update the task successfully' do
          task_updated = uc.new(task_params: params).execute(task_model: task)

          expect(task_updated.description).to eq(valid_task_params[:description])
        end

        context 'changed date of parent task' do
          it 'update the date of subtask successfully' do
            task_updated = uc.new(task_params: params).execute(task_model: task)

            expect(subtask.date.to_date).to eq(task_updated.date.to_date)
          end
        end
      end

      context 'and it is a subtask' do
        let(:parent_task) { create(:task, :with_sub_task) }
        let(:subtask) { parent_task.sub_tasks.first }

        let(:params) {
          {
            id: subtask.id,
            description: "New description"
          }
        }

        it 'update subtask successfully' do
          subtask_updated = uc.new(task_params: params).execute(task_model: subtask)

          expect(subtask_updated.description).to eq(params[:description])
          expect(subtask_updated.parent_id).to eq(parent_task.id)
        end
      end
    end
  end
end