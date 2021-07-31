(module magic.utils
  {autoload {a aniseed.core
             nvim aniseed.nvim
             packer packer
             mapper nvim-mapper}})

;; Plugins
(defn- safe-require-plugin-config [name]
  "Safely require a module under the magic.plugin.* prefix. Will catch errors
  and print them while continuing execution, allowing other plugins to load
  even if one configuration module is broken."
  (let [(ok? val-or-err) (pcall require (.. "magic.plugin." name))]
    (when (not ok?)
      (print (.. "Plugin config error: " val-or-err)))))

(defn req [name]
  "A shortcut to building a require string for your plugin
  configuration. Intended for use with packer's config or setup
  configuration options. Will prefix the name with `magic.plugin.`
  before requiring."
  (.. "require('magic.plugin." name "')"))

(defn use [config ...]
  "Iterates through the arguments as pairs and calls packer's use function for
  each of them. Works around Fennel not liking mixed associative and sequential
  tables as well.

  This is just a helper / syntax sugar function to make interacting with packer
  a little more concise."
  (let [pkgs [...]]
    (packer.startup
      {1 (fn [use]
          (for [i 1 (a.count pkgs) 2]
            (let [name (. pkgs i)
                  opts (. pkgs (+ i 1))]
              (-?> (. opts :mod) (safe-require-plugin-config))
              (use (a.assoc opts 1 name)))))
       :config config})))

;; Mappings
(defn termcode [str]
  (vim.api.nvim_replace_termcodes str true true true))

(def- keymap
  (do
    (var mid 1)
    (fn [mode from action options category id description]
      "Sets a key mapping and store its document in nvim-mapper."
      (if (a.string? action)
        (do
          (nvim.set_keymap mode from action options)
          (if (and (not= nil category) (not= nil id))
            (pcall
              mapper.map mode from action options category id description)))
        (do
          (let [to (.. "keymap_fn_" mid)
                vim-cmd (.. "v:lua." to "()")]
            (nvim.set_keymap mode from vim-cmd options)
            (tset _G to action)
            (if (and (not= nil category) (not= nil id))
              (mapper.map mode from vim-cmd options category id description)))
          (set mid (+ mid 1)))))))

(defn keymaps [configs]
  "Set key mappings"
  (each [mode mode-map (pairs configs)]
    (each [from [action options category id description] (pairs mode-map)]
      (keymap mode from action options category id description))))
