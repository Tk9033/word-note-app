class CardsController < ApplicationController
  before_action :set_deck
  before_action :set_card, only: %i[edit update destroy]

  def new
    @card = @deck.cards.new
  end

  def create
    @card = @deck.cards.new(card_params)

    if @card.save
      redirect_to @deck, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @card は before_action でセット済み
  end

  def update
    if @card.update(card_params)
      redirect_to @deck, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @card.destroy!
    redirect_to @deck, notice: t(".success"), status: :see_other
  end

  private

  def set_deck
    @deck = Deck.find(params[:deck_id])
  end

  def set_card
    @card = @deck.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:question, :answer)
  end
end
