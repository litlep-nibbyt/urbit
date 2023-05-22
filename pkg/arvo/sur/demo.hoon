:: /notes -> notes
:: /notes/[id] -> note
:: /notes/[id]/comments -> comments
:: /notes/[id]/comments/[id] -> comment
::
::  extended face notation
::  foo#name=type
::  binds name=type at /foo suffix
::  #name=type bind name=type at /name suffix
::  
::  ur-datatype
::  noun @ / with potential suffix bindings with #  -> sing publication
::  map subtype of iota -> nouns?  -> mult publication
::
::  queries work backwards
::  to match on the following query we try the following sequence,
::  looking for publications
::  /notes/[nid]/comments/[nid]
::  first:
::  /notes/[nid]/comments/[nid]
::  /notes/[nid]/comments
::  /notes/[nid]
::  /notes
::  this allows for an equivacation between publications and pieces of
::  superior state
::
::  writes work forwards
::  /notes/[nid]/comments/[cid]
::  writes go to the highest publication, which can optionally resign
::  actions to subpublications via an effects, or can assert permissions
::  checks
::  this nests infinitely
::
::  XX: existential publications a la existential types?
::  
::  For checkpointing/tombstoning %mult subscriptions, policies can trivially be
::  set, because the mop is visible to the runtime, runtime probably
::  wants to keep track of a bunch of stuff, but userspace shouldnt care
::  about this. We do not consider tombstoning %sing subscriptions
|%
++  ver
  |%
  ++  notes  /~zod/latest-case/notes/schema
  ::  XX: with protocols, do we want to define adapters, or phylogenetic
  ::  tree of compatible protocols that are not identical??
  --
 
+$  scry-spec  * :: XX: elaborate
+$  notes :: mult publication
  (mop @da (each @uvJ note)) :: TODO: examine sparse merkel sum tree
+$  note
  $:  book=term :: XX: makes assumption about namespace that escapes the publication context
      title=cord :: /notes/[id]/title ->
      desc=cord  ::  /notes/[id]/desc
      content=cord
      src=ship
      =time
      #=comments
  ==
+$  book
  $:  title=cord
      permissions=path
      image=cord
      #=notes
  ==
+$  bath  path
::
+$  bush
  $%  [%poke scm=path who=path wer=path dat=*] :: XX: expand
      :: if .scm is not available, queue poke until it is, and ensure
      :: validation on way out, this encourages subscription + poke
      :: unification because if a subscription is already open then
      :: pokes are always released instantaneously
      :: ex: [%poke /~zod/latest-case/notes/schema ~tondes-sitrym /books/lightning-rfcs/notes/(scot %da now) %add (some-theorycel-nonsense)] :: /pokes.hoon
      [%soak bath=path] :: start synchronisation
      [%wipe bath=path] :: stop synchronisation
      [%grow twig=path plot=path]  :: start publication, installing twig into plot
      [%trim plot=path]            :: stop publication, removing plot
      [%seed ~]                    :: continue poke propagation
  ==
    
::
::  uses the new scry path format beginning /ship/case/everything/else
+$  mult-card
  $%  [%mult mult-gift]
      [%tend bush]
  ==
::
+$  sing-card  bush
::
+$  mult-gift
  %-  pair  iota
  $%  [%add content=*] :: dependent typing to remove bad typing equivalent to a (~(put by))
      [%del ~]
      [%edit new-content=*]
  ==
::
+$  notes-diff
  $%  [[id=@da %add ~] =note]  :: /notes/[id]/add
      [[id=@da %del ~] ~]      :: /notes/[id]/del
      [[id=@da %comments *] *] :: can we add this automatically?
  ==
::
+$  note-diff
  $%  [[%edit ~] content=cord]  :: /notes/[id]/edit
      [[%comments *] *] :: can we add this automatically?
      :: /notes/[id]/comments is automatically rerouted because of the #
      :: rune
  ==
+$  comments
  (mop @da comment)
+$  comment
  $:  parent=@da  :: necessary to keep backlinks?
      content=cord
      src=ship
      =time
      replying=(unit @da)
  ==
::
+$  note
  $:  src=ship
      =time
      content=cord
      #=comments  :: conceptually like a virutalised face?
  ==
+$  id  @da
+$  messages  :: oxal is an ordered axal
  (mop id message)
+$  action
  $%  [%add =id =message]
      [%del =id]
  ==
++  mult
  |_  notes=(mop @da note)
  ++  poke
    |=  diff=note-diff
    ^-  (list mult-card)
    ?>  (do-permissions src.bowl)
    ?:  ?=(%comments -<.diff)
      [%seed ~]
    [%mult diff]~
  ++  scry
    ^-  [scry-spec $-(path cage)]
    :-  *scry-spec  :: ideal scenario, we can annotate the code itself, and it will gen this?
    |=  =path
    ^-  *  :: XX: needs dependent typing
    ?+  path  !!
      [%latest ~]  (scag 100 (tap:orm notes))
    ==
  --
++  sing
  |_  [id=@da =note]
  ++  poke
    |=  [id=@da diff=note-diff]
    ^-  (quip sing-card note)
    ?>  (additional-perm-checks src.bowl)
    ?+  -.diff  [[%seed ~]~ note]
      %edit  `note(content new-content.diff)
    ==
  ::
  ++  scry  :: possibly optional arm? most cases should handle autogenerated paths just fine
    |=  =path
    ^-  [scry-spec $-(path cage)]
    :-  *scry-spec  :: ideal scenario, we can annotate the code itself, and it will gen this?
    |=  =path
    ^-  *  :: XX: needs dependent typing
    !!
  --
--

