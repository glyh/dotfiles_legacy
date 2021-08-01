(module magic.utils
  {autoload {a      aniseed.core
             nvim   aniseed.nvim
             packer packer
             mapper nvim-mapper
             mt     telescope.actions.mt}})

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
(defn- termcode [str]
  (vim.api.nvim_replace_termcodes str true true true))

(defn keymap [mode from action options id category description]
  "Sets a key mapping and store its document in nvim-mapper."
  (if (a.string? action)
    (do
      (nvim.set_keymap mode from action options)
      (if (not= nil category)
        (mapper.map mode from action options category id description)))
    (let [to (.. "keymap_fn_" id)
          vim-cmd (if options.expr
                    (.. "v:lua." to "()")
                    (.."<Cmd>lua " to "()<CR>"))]
      (nvim.set_keymap mode from vim-cmd options)
      (if options.expr
        (tset _G to (fn [] (termcode (action))))
        (tset _G to action))
      (if (not= nil category)
        (mapper.map mode from vim-cmd options category id description)))))

(defn keymap-doc [mode from id category description]
  (mapper.map_virtual mode from "" {} category id description))

(defn f->action [f]
  (mt.transform_mod {:x f}))

(defn join [strs sep]
  (a.reduce
    (fn [acc cur]
      (if (= acc "") cur (.. acc sep cur)))
    "" strs))
