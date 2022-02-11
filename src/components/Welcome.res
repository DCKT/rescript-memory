let button = "border-4 border-purple-400 text-purple-300 dark:text-white px-4 py-2 rounded font-semibold hover:bg-purple-400"
let activeButton = "bg-purple-400 px-4 py-2 rounded"

@react.component
let make = (~onPlayClick, ~difficulty: Game.difficulty, ~setDifficulty) => {
  <div className="flex flex-col gap-8">
    <h1 className="font-shizuru text-[140px] text-purple-500 dark:text-purple-400">
      {"Welcome"->React.string}
    </h1>
    <div className="flex flex-col gap-4">
      <p className="text-center text-4xl uppercase font-shizuru text-purple-300">
        {"Level"->React.string}
      </p>
      <div className="flex flex-row gap-4 justify-center items-center">
        <button
          onClick={_ => setDifficulty(Game.Easy)}
          className={cx([button, difficulty === Game.Easy ? activeButton : ""])}>
          {"Easy"->React.string}
        </button>
        <button
          onClick={_ => setDifficulty(Game.Medium)}
          className={cx([button, difficulty === Game.Medium ? activeButton : ""])}>
          {"Medium"->React.string}
        </button>
        <button
          onClick={_ => setDifficulty(Game.Hard)}
          className={cx([button, difficulty === Game.Hard ? activeButton : ""])}>
          {"Hard"->React.string}
        </button>
      </div>
    </div>
    <button
      className="text-3xl w-48 bg-gradient-to-r from-purple-300 to-purple-500 hover:from-purple-500 block p-4 rounded-lg font-semibold text-white mx-auto"
      onClick={_ => onPlayClick()}>
      {"Play"->React.string}
    </button>
  </div>
}
