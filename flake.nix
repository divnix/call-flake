{
  outputs = inputs: let
    wrapper = import ./.;
  in {
    __functor = _: wrapper;
  };
}
