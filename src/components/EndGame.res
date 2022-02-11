@react.component
let make = (~onReplayClick, ~onBackHomeClick) => {
  <div className="flex flex-col gap-4">
    <h1 className="text-[100px] font-bold text-purple-500 font-shizuru">
      {"Congratulations"->React.string}
    </h1>
    <div className="flex flex-row justify-center items-center gap-8">
      <button
        className="text-3xl w-48 bg-gradient-to-r from-purple-300 to-purple-500 block p-4 rounded-lg font-semibold text-white mx-auto"
        onClick={_ => onBackHomeClick()}>
        {"Back home"->React.string}
      </button>
      <button
        className="text-3xl w-48 bg-gradient-to-r from-purple-300 to-purple-500 block p-4 rounded-lg font-semibold text-white mx-auto"
        onClick={_ => onReplayClick()}>
        {"Replay"->React.string}
      </button>
    </div>
  </div>
}
