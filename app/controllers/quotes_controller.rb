class QuotesController < ApplicationController
  
  before_filter :login_required, :except => [ :index, :latest, :rss, :show, :new, :create, :vote ]
  
  def index
  end
  
  def latest
    @quotes = Quote.paginate(:per_page => 20, :page => params['page'],
                             :conditions => ["approved = ?", true],
                             :order => "id DESC")
  end
  
  def rss
    @quotes = Quote.find_all_by_approved(true, :order => "id DESC", :limit => 15)
    render :template => "quotes/rss.xml.builder", :layout => false
  end
  
  def show
    @quote = Quote.find(params[:id])
  end

  def new
    @quote = Quote.new
  end

  def edit
    @quote = Quote.find(params[:id])
  end

  def create
    @quote = Quote.new(params[:quote])

    if @quote.save
      flash[:notice] = 'Quote successfully submitted. Your quote will now be reviewed by a moderator.'
      redirect_to root_url
    else
      render :action => "new"
    end
  end

  def update
    @quote = Quote.find(params[:id])
    
    if @quote.update_attributes(params[:quote])
      flash[:notice] = 'Quote was successfully updated.'
      redirect_to(@quote)
    else
      render :action => "edit"
    end
  end

  def destroy
    @quote = Quote.find(params[:id])
    @quote.destroy
    
    if request.xhr? # AJAX request
      render :text => "<p style=\"color: red\">Quote #{params[:id]} was successfully <em>deleted</em>.</p>"
    else # normal request
      flash[:notice] = "Quote #{params[:id]} was successfully deleted."
      redirect_to :action => 'queue'
    end
  end
  
  def approve
    @quote = Quote.find(params[:id])
    @quote.update_attribute(:approved, true)

    if request.xhr? # AJAX request
      render :text => "<p style=\"color: green\">Quote #{params[:id]} was successfully <em>approved</em>.</p>"
    else # normal request
      flash[:notice] = "Quote ##{params[:id]} was successfully approved."
      redirect_to :action => 'queue'
    end
  end
  
  def vote
    @quote = Quote.find(params[:id])
    voter_ip = Ip.find_or_create_by_ip(IPAddr.new(request.remote_ip).to_i)
    positive = (params[:up_or_down] == 'up')
    vote = Vote.new(:quote => @quote, :ip => voter_ip, :positive => positive)
    vote.save
    
    if request.xhr? # AJAX request
      render :text => "#{@quote.rating} (#{@quote.votes.count})"
    else # normal request
      if vote.errors.empty?
        flash[:notice] = "Quote ##{@quote.id} was successfully voted #{params[:up_or_down]}."
      else
        flash[:error] = "You have already voted on Quote ##{@quote.id}."
      end
      redirect_back_or_default("/#{@quote.id}")
    end
  end
  
end
