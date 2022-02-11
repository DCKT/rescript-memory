module BsMoonStars = {
  @module("react-icons/bs") @react.component
  external make: (~size: int=?) => React.element = "BsMoonStars"
}

let innerCardStyle = "rounded-lg absolute text-center top-0 left-0 w-full h-full flex justify-center items-center backface-hidden"

@react.component
let make = (~onClick, ~isSelected, ~value) => {
  <button
    onClick={_ => {
      if !isSelected {
        onClick()
      }
    }}
    className={cx(["card relative w-32 h-40", isSelected ? "card--selected" : "cursor-pointer"])}>
    <div
      className="inner-card relative w-full h-full transition-transform duration-700 transform-preserve-3d">
      <div
        className={cx([
          innerCardStyle,
          "card-back text-purple-800 bg-purple-200 dark:bg-purple-300 shadow hover:bg-purple-200",
        ])}>
        <BsMoonStars size={28} />
      </div>
      <div className={cx([innerCardStyle, "card-front bg-purple-50"])}> {value->React.int} </div>
    </div>
  </button>
}
