class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /events
  # GET /events.json
  def index
    @created_events = current_user.created_events
    @invited_events = current_user.invited_events
    @attending_events = current_user.attending_events
  end

  # GET /events/1
  # GET /events/1.json
  def show
    if current_user != @event.creator && !@event.invitees.include?(current_user) && !@event.attendees.include?(current_user)
        redirect_to root_path, alert: "You don't have permission to do that"
    else 
        if !current_user.attending_events.include?(@event) && @event.invitees.include?(current_user)
            current_user.attending_events << @event
            current_user.user_events.find_by(event_id: @event.id).destroy
        end
    end
  end

  # GET /events/new
  def new
    @event = current_user.created_events.new()
  end

  # GET /events/1/edit
  def edit
    if current_user != @event.creator
        redirect_to @event, alert: 'You are not the creator of this event'
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.created_events.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }

        @event.invitees_email.split(',').each do | user_email |
            user = User.find_by(email: user_email)
            @event.invitees << user
        end
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }

        @event.invitees_email.split(',').each do | user_email |
            user = User.find_by(email: user_email)
            
            unless @event.invitees.include?(user) || @event.attendees.include?(user)
                @event.invitees << user
            end
        end
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    if current_user != @event.creator
        redirect_to @event, alert: 'You are not the creator of this event'
    else
        @event.destroy
        respond_to do |format|
        format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
        format.json { head :no_content }
        end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:info, :invitees_email)
    end
end
