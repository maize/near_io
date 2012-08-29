class GroupsController < ApplicationController
  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all

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
    @group = Group.new(params[:group])

    # Facebook Group
    unless params[:group][:facebook_group].empty?
      fb_group = FacebookGroup.find_by_facebook_id(params[:group][:facebook_group])
      @group.facebook_group = fb_group
    end

    # Facebook Page
    unless params[:group][:facebook_page].empty?
      fb_page = FacebookPage.find_by_facebook_id(params[:group][:facebook_page])
      @group.facebook_page = fb_page
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

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])
    
    networks = []
    network = Network.find(params[:group][:networks])
    networks.push(network)
    params[:group][:networks] = networks

    unless params[:group][:facebook_group].empty?
      fb_group = FacebookGroup.find_by_facebook_id(params[:group][:facebook_group].to_i)
      params[:group][:facebook_group] = fb_group
    end

    unless params[:group][:facebook_page].empty?
      fb_page = FacebookPage.find_by_facebook_id(params[:group][:facebook_page].to_i)
      params[:group][:facebook_page] = fb_page
    end

    respond_to do |format|
      if @group.update_attributes(params[:group])
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
