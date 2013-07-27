{-# LANGUAGE ForeignFunctionInterface, JavaScriptFFI, CPP #-}

module GHCJS.History where

import GHCJS.Types
import GHCJS.DOM.Types
import GHCJS.Foreign
import GHCJS.Marshal

historyAdapterBind :: (IsDOMWindow a, ToJSString b) => a -> b -> (Event -> IO ()) -> IO ()
historyAdapterBind a b f = do
  callback <- syncCallback1 False True $ \e -> f (unsafeCastGObject $ GObject e)
  js_historyAdapterBind (unDOMWindow $ toDOMWindow a) (toJSString b) callback

historyPushState :: (ToJSRef a, ToJSString b, ToJSString c) => a -> b -> c -> IO ()
historyPushState s t u = do
  r <- toJSRef s
  js_historyPushState r (toJSString t) (toJSString u)

historyReplaceState :: (ToJSRef a, ToJSString b, ToJSString c) => a -> b -> c -> IO ()
historyReplaceState s t u = do
  r <- toJSRef s
  js_historyReplaceState r (toJSString t) (toJSString u)

#ifdef __GHCJS__
foreign import javascript unsafe
  "History[\"Adapter\"][\"bind\"]($1, $2, $3)"
  js_historyAdapterBind :: JSRef DOMWindow -> JSString -> JSRef a -> IO ()

foreign import javascript unsafe
  "History[\"pushState\"]($1, $2, $3)"
  js_historyPushState :: JSRef a -> JSString -> JSString -> IO ()

foreign import javascript unsafe
  "History[\"replaceState\"]($1, $2, $3)"
  js_historyReplaceState :: JSRef a -> JSString -> JSString -> IO ()
#else
js_historyAdapterBind :: JSRef DOMWindow -> JSString -> JSRef a -> IO ()
js_historyAdapterBind = undefined

js_historyPushState :: JSRef a -> JSString -> JSString -> IO ()
js_historyPushState = undefined

js_historyReplaceState :: JSRef a -> JSString -> JSString -> IO ()
js_historyReplaceState = undefined
#endif
