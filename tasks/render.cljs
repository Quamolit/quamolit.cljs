
(ns workflow.boot
  (:require
    [respo.alias :refer [html head title script style meta' div link body canvas]]
    [respo.render.html :refer [make-html make-string]]))

(defn html-dsl [data]
  (make-html
    (html {}
      (head {}
        (title {:attrs {:innerHTML "Quamolit"}})
        (link {:attrs {:rel "icon" :type "image/png" :href "quamolit.png"}})
        (link (:attrs {:rel "manifest" :href "manifest.json"}))
        (meta' {:attrs {:charset "utf-8"}})
        (meta' {:attrs {:name "viewport" :content "width=device-width, initial-scale=1"}})
        (style {:attrs {:innerHTML "body {margin: 0;}"}})
        (style {:attrs {:innerHTML "body * {box-sizing: border-box;}"}})
        (script {:attrs {:id "config" :type "text/edn" :innerHTML (pr-str data)}}))
      (body {}
        (canvas {:attrs {:id "app" :tabindex 1}})
        (script {:attrs {:src "main.js"}})))))

(defn generate-empty-html []
  (html-dsl {:build? true}))

(defn spit [file-name content]
  (let [fs (js/require "fs")]
    (.writeFileSync fs file-name content)))

(defn -main []
  (spit "target/index.html" (generate-empty-html)))

(-main)
