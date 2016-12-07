module type AppType =
sig
  type model
  type action
  val init : model * action list Lwt.t
  val update : model -> action -> model * action list Lwt.t
  val subscriptions : model -> action list Lwt.t
  val view :
    model React.signal ->
    (action -> unit) -> [> Html_types.div ] Tyxml_js.Html5.elt
end
module type S = sig val main : unit -> unit Lwt.t end
module Make : functor (App : AppType) -> S

