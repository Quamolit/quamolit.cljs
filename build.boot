
(set-env!
  :asset-paths #{"assets"}
  :resource-paths #{"polyfill/" "src/"}
  :dependencies '[[org.clojure/clojure       "1.8.0"       :scope "test"]
                  [org.clojure/clojurescript "1.9.521"     :scope "test"]
                  [adzerk/boot-cljs          "1.7.228-1"   :scope "test"]
                  [adzerk/boot-reload        "0.4.13"      :scope "test"]
                  [binaryage/devtools        "0.9.2"       :scope "test"]
                  [respo                     "0.3.32"      :scope "test"]
                  [mvc-works/hsl             "0.1.2"]])

(require '[adzerk.boot-cljs   :refer [cljs]]
         '[adzerk.boot-reload :refer [reload]])

(deftask dev! []
  (comp
    (watch)
    (reload :on-jsload 'quamolit.main/on-jsload
            :cljs-asset-path ".")
    (cljs :compiler-options {:language-in :ecmascript5})
    (target)))

(deftask build-advanced []
  (comp
    (cljs :optimizations :advanced
          :compiler-options {:language-in :ecmascript5
                             ; :pseudo-names true
                             ; :static-fns true
                             ; :optimize-constants true
                             :parallel-build true})
    (target)))

(def +version+ "0.1.6")

(deftask build []
  (comp
    (pom :project     'quamolit/quamolit
         :version     +version+
         :description "Quamolit is declarative animation library for Canvas"
         :url         "https://github.com/Quamolit/quamolit"
         :scm         {:url "https://github.com/Quamolit/quamolit"}
         :license     {"MIT" "http://opensource.org/licenses/mit-license.php"})
    (jar)
    (install)
    (target)))

(deftask deploy []
  (set-env!
    :repositories #(conj % ["clojars" {:url "https://clojars.org/repo/"}]))
  (comp
    (build)
    (push :repo "clojars" :gpg-sign (not (.endsWith +version+ "-SNAPSHOT")))))
