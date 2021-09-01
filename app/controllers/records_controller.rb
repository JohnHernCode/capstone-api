class RecordsController < ApplicationController
  before_action :authorized
  before_action :set_record, only: %i[show update destroy]

  def index
    @records = Record.all_records(@current_user)
    @record_dates = Record.all_record_dates(@current_user)

    if @records
      render json: { records: @records, record_dates: @record_dates }, status: 200
    else
      render json: 'No records yet'
    end
  end

  def show
    if @record
      render json: @record, status: 200
    else
      render json: { error: 'Record not found' }, status: 404
    end
  end

  def create
    @record = @current_user.records.new(rec_pms)
    if @record.save
      render json: @record, status: 201
    else
      render json: { error: 'Track could not be created.' }, status: 422
    end
  end

  def update
    if @record.update(rec_pms)
      render json: @record, status: 200
    else
      render json: { error: 'Track could not be updated.' }, status: 422
    end
  end

  def destroy
    if @record
      @record.destroy
      render json: { message: 'Successfully deleted', deleted_record: @record }, status: 200
    else
      render json: { error: 'Sorry, Record could not be deleted' }, status: 422
    end
  end

  private

  def set_record
    @record = @current_user.records.find(params[:id])
  end

  def rec_pms
    params.require(:record).permit(:result, :item_id, :date, :itemId)
  end
end
