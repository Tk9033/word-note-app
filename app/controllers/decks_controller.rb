class DecksController < ApplicationController
  before_action :set_deck, only: %i[show edit update destroy]

  def index
    scope = current_user.decks.includes(:cards)
    dir = %i[asc desc].include?(params[:dir]&.to_sym) ? params[:dir] : :desc
      @decks =
      case params[:sort]
      when "name"       then scope.order(name: dir)
      when "created_at" then scope.order(created_at: dir)
      else                    scope.order(created_at: :desc)
      end
  end

  def show
    # @deckはbefore_actionでセット済み
    @cards = @deck.cards.order(created_at: :desc)
  end

  def new
    @deck = current_user.decks.new
  end

  def edit
    # @deckはbefore_actionでセット済み
  end

  def create
    @deck = current_user.decks.build(deck_params)

    if @deck.save
      redirect_to @deck, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @deck.update(deck_params)
      redirect_to @deck, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @deck.destroy!
    redirect_to decks_url, notice: t(".success"), status: :see_other
  end

  private

  def set_deck
    @deck = current_user.decks.find(params[:id])
  end

  def deck_params
    params.require(:deck).permit(:name)
  end
end
