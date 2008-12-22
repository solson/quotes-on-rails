class QuotesController < ApplicationController
  
  #require_role :admin, :for => [ :edit, :update, :destroy, :approve ]
  
  def index
    
  end
  
  def latest
    @quotes = Quote.paginate :per_page => 20, :page => params['page'],
                             :conditions => ["approved = ?", true],
                             :order => "id DESC"
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
      flash[:notice] = "Quote #{params[:id]} was successfully approved."
      redirect_to :action => 'queue'
    end
  end
  
  def vote
    @quote = Quote.find(params[:id])
    vote = Vote.new(:quote => @quote)
    
    if request.xhr?
      render :text => @quote.rating
    else
      flash[:notice] = "Quote #{params[:id]} was successfully voted."
      redirect_to short_quote_url(@quote)
    end
    
  end
  
end
