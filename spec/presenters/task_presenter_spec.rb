require 'rails_helper'

describe TaskPresenter do
  let(:task) { create(:task, :done) }
  let(:presenter) { described_class.new(task: task) }

  describe "#description" do

    it 'return a description task' do
      expect(presenter.description).to eq(task.description)
    end
  end

  describe '#done?' do
    context "when the task is finished" do
      it 'returns true' do
        expect(presenter.done?).to eq(true)
      end
    end

    context "when the task is not finished" do
      let(:task) { create(:task) }
      let(:presenter) { described_class.new(task: task) }

      it 'returns false' do
        expect(presenter.done?).to eq(false)
      end
    end
  end

  describe 'has_sub_task?' do
    context 'when the task has a sub task' do
      let(:task) { create(:task, :with_sub_task) }
      let(:presenter) { described_class.new(task: task) }

      it "returns true" do
        expect(presenter.has_sub_task?).to eq(true)
      end
    end

    context 'when the task has no sub task' do
      let(:task) { create(:task) }
      let(:presenter) { described_class.new(task: task) }

      it "returns true" do
        expect(presenter.has_sub_task?).to eq(false)
      end
    end
  end

  describe '#sub_tasks' do
    context 'when the task has a sub task' do
      let(:task) { create(:task, :with_sub_task) }
      let(:presenter) { described_class.new(task: task) }

      it "returns a array of sub tasks presenters class" do
        expect(presenter.sub_tasks).to include(be_an_instance_of(TaskPresenter))
      end
    end

    context 'when the task has no sub task' do
      let(:task) { create(:task) }
      let(:presenter) { described_class.new(task: task) }

      it "returns a empty array" do
        expect(presenter.sub_tasks).to eq([])
      end
    end
  end
end