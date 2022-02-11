type difficulty =
  | Easy
  | Medium
  | Hard

let getCardsByDifficulty = difficulty => {
  let tmp = Array.makeBy(
    switch difficulty {
    | Easy => 6
    | Medium => 10
    | Hard => 16
    },
    i => i,
  )

  tmp->Array.concat(tmp)->Array.shuffle
}
