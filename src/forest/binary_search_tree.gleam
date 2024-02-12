import gleam/option.{type Option, None, Some}
import gleam/order
import gleam/int
import gleam/list

// TODO
// Finish methods
//     use `set`'s interface
// Order of api and tests
// Do we really want to have to pass in a `compare` function into the public api?
// Where can we refactor?
// Implement binary search tree with a binary tree?
//     Impelemnt binary tree with a tree?

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
            NodeState(..state, right: update_tree(state.right, value, compare)),
          ))
        order.Gt ->
          Node(Some(
            NodeState(..state, left: update_tree(state.left, value, compare)),
          ))
        order.Eq -> tree
      }
    None ->
      Node(Some(NodeState(value: value, left: option.None, right: option.None)))
  }
}

fn update_tree(
  tree: Option(Node(a)),
  value: a,
  compare: fn(a, a) -> order.Order,
) -> Option(Node(a)) {
  case tree {
    Some(node) -> Some(insert(node, value, compare))
    None -> Some(Node(Some(NodeState(value: value, left: None, right: None))))
  }
}

// pub fn delete(tree: Node(a), value: a) -> Node(a) {
//   case tree.state {
//     Some(node) -> {
//       todo
//     }
//     None -> tree
//   }
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

pub fn height(tree: Node(a)) -> Int {
  case tree.state {
    Some(state) -> {
      let left =
        state.left
        |> option.map(height)
        |> option.unwrap(-1)

      let right =
        state.right
        |> option.map(height)
        |> option.unwrap(-1)

      1 + int.max(left, right)
    }
    None -> -1
  }
}

// pub fn depth() -> a {
//   0
// }

pub fn size(tree: Node(a)) -> Int {
  case tree.state {
    Some(state) -> {
      let left =
        state.left
        |> option.map(size)
        |> option.unwrap(0)

      let right =
        state.right
        |> option.map(size)
        |> option.unwrap(0)

      1 + left + right
    }
    None -> 0
  }
}

pub fn from_list(items: List(a), compare: fn(a, a) -> order.Order) -> Node(a) {
  // Reorder list for balanced insertion

  let tree = new()
  case items {
    [] -> tree
    items -> do_from_list(tree, items, compare)
  }
}

fn do_from_list(
  tree: Node(a),
  items: List(a),
  compare: fn(a, a) -> order.Order,
) -> Node(a) {
  case items {
    [] -> tree
    [first, ..items] ->
      do_from_list(insert(tree, first, compare), items, compare)
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

pub fn min(tree: Node(a)) -> Result(a, Nil) {
  case tree.state {
    Some(state) -> {
      state.left
      |> option.map(min)
      |> option.unwrap(Ok(state.value))
    }
    None -> Error(Nil)
  }
}

pub fn max(tree: Node(a)) -> Result(a, Nil) {
  case tree.state {
    Some(state) -> {
      state.right
      |> option.map(max)
      |> option.unwrap(Ok(state.value))
    }
    None -> Error(Nil)
  }
}
