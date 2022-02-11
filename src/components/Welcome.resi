@react.component
let make: (
  ~onPlayClick: unit => unit,
  ~difficulty: Game.difficulty,
  ~setDifficulty: Game.difficulty => unit,
) => React.element
