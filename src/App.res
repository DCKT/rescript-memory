let tmp = Array.makeBy(5, i => i)
let cards = tmp->Array.concat(tmp)->Array.shuffle

type rec state = {
  selectedCards: array<card>,
  cardOne: option<card>,
  cardTwo: option<card>,
  preventClick: bool,
  gameState: gameState,
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
  | CardsFound(card, card)

let initialState = {
  selectedCards: [],
  cardOne: None,
  cardTwo: None,
  gameState: Home,
  preventClick: false,
}

@react.component
let make = () => {
  let (
    {selectedCards, cardOne, cardTwo, gameState, preventClick},
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
          gameState: Playing,
        })
      | CardsFound(card1, card2) => {
          let selectedCards = state.selectedCards->Array.concat([card1, card2])

          if selectedCards->Array.length === cards->Array.length {
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
    | Win => <EndGame onReplayClick={() => dispatch(Play)} />
    | Home => <Welcome onPlayClick={() => dispatch(Play)} />
    | Playing =>
      <div className="grid grid-cols-4 gap-8">
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
