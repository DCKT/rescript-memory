@react.component
let make = (~onPlayClick) => {
  <div className="flex flex-col gap-8">
    <h1 className="font-shizuru text-[140px] text-purple-500 dark:text-purple-400">
      {"Welcome"->React.string}
    </h1>
    <button
      className="text-3xl w-48 bg-gradient-to-r from-purple-300 to-purple-500 block p-4 rounded-lg font-semibold text-white mx-auto"
      onClick={_ => onPlayClick()}>
      {"Play"->React.string}
    </button>
  </div>
}
