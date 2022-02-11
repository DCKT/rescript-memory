type rec state = {
  cards: array<int>,
  selectedCards: array<card>,
  cardOne: option<card>,
  cardTwo: option<card>,
  preventClick: bool,
  gameState: gameState,
  difficulty: Game.difficulty,
}
and card = {
  index: int,
  value: int,
}
and gameState =
  | Home
  | Playing
  | Win

type action =
  | SelectCard(card)
  | ResetCards
  | Play
  | BackHome
  | SetDifficulty(Game.difficulty)
  | CardsFound(card, card)

let initialState = {
  cards: [],
  selectedCards: [],
  cardOne: None,
  cardTwo: None,
  gameState: Home,
  preventClick: false,
  difficulty: Game.Easy,
}

@react.component
let make = () => {
  let (
    {selectedCards, cardOne, cardTwo, gameState, preventClick, difficulty, cards},
    dispatch,
  ) = ReactUpdate.useReducerWithMapState(
    (state, action) => {
      switch action {
      | SelectCard(card) =>
        switch state.cardOne {
        | None => Update({...state, cardOne: Some(card)})
        | Some(card1) =>
          if card1.value === card.value {
            UpdateWithSideEffects(
              {...state, cardTwo: Some(card)},
              self => {
                self.dispatch(CardsFound(card1, card))

                None
              },
            )
          } else {
            UpdateWithSideEffects(
              {...state, cardTwo: Some(card), preventClick: true},
              self => {
                let id = Js.Global.setTimeout(() => {
                  self.dispatch(ResetCards)
                }, 1000)

                Some(
                  () => {
                    Js.Global.clearTimeout(id)
                  },
                )
              },
            )
          }
        }
      | ResetCards => Update({...state, cardOne: None, cardTwo: None, preventClick: false})
      | Play =>
        Update({
          ...initialState,
          difficulty: state.difficulty,
          cards: Game.getCardsByDifficulty(state.difficulty),
          gameState: Playing,
        })
      | BackHome => Update(initialState)
      | SetDifficulty(difficulty) => Update({...state, difficulty: difficulty})
      | CardsFound(card1, card2) => {
          let selectedCards = state.selectedCards->Array.concat([card1, card2])

          if selectedCards->Array.length === state.cards->Array.length {
            Update({
              ...state,
              gameState: Win,
            })
          } else {
            Update({
              ...state,
              selectedCards: selectedCards,
              cardOne: None,
              cardTwo: None,
              preventClick: false,
            })
          }
        }
      }
    },
    () => initialState,
  )

  <div className="flex w-full h-full justify-center items-center bg-blue-50 dark:bg-gray-700">
    {switch gameState {
    | Win =>
      <EndGame onReplayClick={() => dispatch(Play)} onBackHomeClick={() => dispatch(BackHome)} />
    | Home =>
      <Welcome
        difficulty
        setDifficulty={difficulty => dispatch(SetDifficulty(difficulty))}
        onPlayClick={() => dispatch(Play)}
      />
    | Playing =>
      <div
        className={cx([
          "grid gap-8",
          switch difficulty {
          | Game.Easy => "grid-cols-4"
          | Game.Medium => "grid-cols-5"
          | Game.Hard => "grid-cols-8"
          },
        ])}>
        {cards
        ->Array.mapWithIndex((i, value) => {
          <Card
            key={i->Int.toString}
            value
            onClick={_ => {
              if !preventClick {
                dispatch(
                  SelectCard({
                    index: i,
                    value: value,
                  }),
                )
              }
            }}
            isSelected={selectedCards->Array.some(({index}) => index === i) ||
            cardOne->Option.mapWithDefault(false, ({index}) => index === i) ||
            cardTwo->Option.mapWithDefault(false, ({index}) => index === i)}
          />
        })
        ->React.array}
      </div>
    }}
  </div>
}
