
(set-env!
  :asset-paths #{"assets"}
  :resource-paths #{"polyfill/" "src/"}
  :dependencies '[])

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
