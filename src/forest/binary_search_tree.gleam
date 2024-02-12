import gleam/option.{type Option, None, Some}
import gleam/order
import gleam/result
import gleam/list

// TODO
// Finish methods
//    use `set`'s interface
// Order of api and tests

pub opaque type NodeState(a) {
  NodeState(value: a, left: Option(Node(a)), right: Option(Node(a)))
}

pub opaque type Node(a) {
  Node(state: option.Option(NodeState(a)))
}

pub fn new() -> Node(a) {
  Node(state: None)
}

pub fn insert(
  tree: Node(a),
  value: a,
  compare: fn(a, a) -> order.Order,
) -> Node(a) {
  case tree.state {
    Some(state) ->
      case compare(state.value, value) {
        order.Lt ->
          Node(Some(
            NodeState(
              ..state,
              right: update_subtree(state.right, value, compare),
            ),
          ))
        order.Gt ->
          Node(Some(
            NodeState(..state, left: update_subtree(state.left, value, compare)),
          ))
        order.Eq -> tree
      }
    None ->
      Node(Some(NodeState(value: value, left: option.None, right: option.None)))
  }
}

fn update_subtree(
  subtree: Option(Node(a)),
  value: a,
  compare: fn(a, a) -> order.Order,
) -> Option(Node(a)) {
  case subtree {
    Some(node) -> Some(insert(node, value, compare))
    None -> Some(Node(Some(NodeState(value: value, left: None, right: None))))
  }
}

// pub fn remove(tree: Node, value: a) -> Node {
//   todo
// }

pub fn contains(
  tree: Node(a),
  value: a,
  compare: fn(a, a) -> order.Order,
) -> Bool {
  case tree.state {
    Some(state) ->
      case compare(state.value, value) {
        order.Lt ->
          state.right
          |> option.map(fn(node) { contains(node, value, compare) })
          |> option.unwrap(False)
        order.Gt ->
          state.left
          |> option.map(fn(node) { contains(node, value, compare) })
          |> option.unwrap(False)
        order.Eq -> True
      }
    None -> False
  }
}

// pub fn path(tree: Node, value: a) -> Result(List(a), Nil) {
//   Error(Nil)
// }

// pub fn debug_print(tree: Node) {
//   todo
// }

// pub fn balance(tree: Node) -> Node {
//   todo
// }

// pub fn height() -> a {
//   0
// }

// pub fn depth() -> a {
//   0
// }

pub fn size(tree: Node(a)) -> Int {
  case tree.state {
    Some(state) -> {
      let left = case state.left {
        Some(node) -> size(node)
        None -> 0
      }

      let right = case state.right {
        Some(node) -> size(node)
        None -> 0
      }

      1 + left + right
    }
    None -> 0
  }
}

pub fn to_list(tree: Node(a)) -> List(a) {
  case tree.state {
    Some(state) -> {
      let left =
        state.left
        |> option.map(to_list)
        |> option.unwrap([])

      let right =
        state.right
        |> option.map(to_list)
        |> option.unwrap([])

      [left, [state.value], right]
      |> list.flatten()
    }
    None -> []
  }
}
// // Might not make sense - could just call insert in a loop
// pub fn from_list() -> List(a) {
//   []
// }

// pub fn min() -> a {
//   0
// }

// pub fn max() -> a {
//   0
// }
