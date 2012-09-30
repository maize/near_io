class NetworksController < ApplicationController
  # GET /networks
  # GET /networks.json
  def index
    @networks = Network.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @networks }
    end
  end

  # GET /networks/1
  # GET /networks/1.json
  def show
    @network = Network.find_by_slug(params[:id])

    unless params[:year].nil? and params[:month].nil? and params[:day].nil?
      date = Time.parse(params[:year]+"-"+params[:month]+"-"+params[:day])
      p "Found date in URL: "+date.to_s
    else
      date = Time.now
      p "Take current time: "+date.to_s
    end

    @events = Event.where(:start_time.gt => date, :start_time.lt => (date+1.day)).asc(:start_time).page params[:page]

    #

    # @network.groups.each do |group|
    #   # @events = @events + group.events
    #   @events = @events + group.events.where(:start_time.gt => Time.now)
    # end

    # @events.sort_by!(&:start_time).reverse!

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @network }
    end
  end

  def update_groups
    Resque.enqueue(UpdateGroups)
    render :nothing => true
  end

  def clear_queue
    p "Beforing clearing queue: "+Qu.length.to_s
    Qu.clear
    p "Cleared queue: "+Qu.length.to_s
    render :nothing => true
  end

  # GET /networks/new
  # GET /networks/new.json
  def new
    @network = Network.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @network }
    end
  end

  # GET /networks/1/edit
  def edit
    @network = Network.find_by_slug(params[:id])
  end

  # POST /networks
  # POST /networks.json
  def create
    @network = Network.new(params[:network])

    respond_to do |format|
      if @network.save
        format.html { redirect_to @network, notice: 'Network was successfully created.' }
        format.json { render json: @network, status: :created, location: @network }
      else
        format.html { render action: "new" }
        format.json { render json: @network.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /networks/1
  # PUT /networks/1.json
  def update
    @network = Network.find(params[:id])

    respond_to do |format|
      if @network.update_attributes(params[:network])
        format.html { redirect_to @network, notice: 'Network was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @network.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /networks/1
  # DELETE /networks/1.json
  def destroy
    @network = Network.find(params[:id])
    @network.destroy

    respond_to do |format|
      format.html { redirect_to networks_url }
      format.json { head :no_content }
    end
  end
end
