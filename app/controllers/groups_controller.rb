class GroupsController < ApplicationController
  load_and_authorize_resource
  
  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all.page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new

    # Get Facebook ID of URL
    link_array = params[:group][:facebook_page][:link].split("/")
    last_part_array = link_array[link_array.size-1].split("?")
    fb_id = last_part_array[0]

    # Possible Facebook models
    fb_group = FacebookGroup.find_by_facebook_id(fb_id)
    fb_page = FacebookPage.find_by_facebook_id(fb_id)

    # Check for validity
    if fb_group.valid?
      p "Group is a Facebook group"
      fb_model = fb_group
      @group = Group.where('facebook_group.facebook_id' => fb_model.facebook_id).first
      if @group.nil?
        @group = Group.new
      end
      @group.facebook_group = fb_model
    elsif fb_page.valid?
      p "Group is a Facebook page"
      fb_model = fb_page
      @group = Group.where('facebook_page.facebook_id' => fb_model.facebook_id).first
      if @group.nil?
        @group = Group.new
      end
      @group.facebook_page = fb_model
    end

    # Networks
    network = Network.find(params[:group][:network_ids])
    unless @group.networks.include?(network)
      networks = []
      networks.push(network)
      @group.networks = networks
    end

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_details
    @group = Group.find(params[:id])
    @group.update_details(current_user.token)
    render :nothing => true
  end

  def events
    @group = Group.find(params[:id])
    @events = FacebookEvent.get_all_by_facebook_id(@group.facebook_id, current_user.token)
    render :nothing => true
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])
    
    networks = []
    network = Network.find(params[:group][:networks])
    networks.push(network)
    unless @group.networks.include?(network)
      @group.networks = networks
    end

    unless params[:group][:facebook_group].empty?
      fb_group = FacebookGroup.find_by_facebook_id(params[:group][:facebook_group].to_i)
      @group.facebook_group = fb_group
    end

    unless params[:group][:facebook_page].empty?
      fb_page = FacebookPage.find_by_facebook_id(params[:group][:facebook_page].to_i)
      @group.facebook_page = fb_page
    end

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end
end
