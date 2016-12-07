open Lwt.Infix

module App = struct
  (** Model *)
  type model = int

  (** Update *)
  type action = Incr | Decr

  let init = 0, Lwt.return []

  let update m = function
    | Incr -> m+1, Lwt.return []
    | Decr -> m-1, Lwt.return []
        
  let subscriptions _ = Lwt.return []

  (** View *)
  let view rm notify =
    let open Tyxml_js in
    let open Html5 in
    div [
      button ~a:[a_onclick (fun evt ->
          notify Decr;
          true
        )] [pcdata "-"];

      R.Html5.pcdata @@ React.S.map string_of_int rm;

      button ~a:[a_onclick (fun evt ->
          notify Incr;
          true
        )] [pcdata "+"];
    ]
end

module M = Elm_arch.Make(App) 

let _ = M.main ()
