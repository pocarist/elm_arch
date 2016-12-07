open Lwt.Infix

let logf fmt = Printf.ksprintf (fun s -> Firebug.console##log(Js.string s)) fmt

module type AppType = sig
  type model
  type action

  val init : model * action list Lwt.t
  val update : model -> action -> model * action list Lwt.t
  val subscriptions : model -> action list Lwt.t
  val view : model React.signal -> (action -> unit)
    -> [> Html_types.div ] Tyxml_js.Html5.elt
end

module type S = sig
  val main : unit -> unit Lwt.t 
end

module Make (App : AppType) : S = struct
  let rec dispatch f rm a =
    let m = React.S.value rm in
    let m, al = App.update m a in
    f m;
    gather f rm al >>= fun rm ->
    let m = React.S.value rm in
    let al = App.subscriptions m in
    gather f rm al
  and gather f rm al =
    al >>= fun xs ->
    xs
    |> Lwt_list.fold_left_s (dispatch f) rm

  let main () =
    Lwt_js_events.onload () >>= fun _ ->
    let doc = Dom_html.document in
    let parent =
      Js.Opt.get (doc##getElementById (Js.string "main"))
        (fun () -> assert false)
    in
    let m, al = App.init in
    let rm, f = React.S.create m in
    gather f rm al >>= fun rm ->
    let notify a =
      dispatch f rm a
      |> Lwt.ignore_result;
    in
    App.view rm notify
    |> Tyxml_js.To_dom.of_div
    |> Dom.appendChild parent
    |> Lwt.return
end
