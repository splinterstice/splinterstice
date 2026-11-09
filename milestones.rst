.. role:: strike
   :class: strike

========================
Splinterstice Milestones
========================

:Tracks: ``splinterstice-roadmap.rst`` (sections 6.1 - 6.6)
:Status: Active Development
:Total nominal schedule: 17 months across 6 phases

Live, hand-editable progress tracker. The overall bar at the top fills toward each phase checkpoint in order. When it reaches a checkpoint, that phase is crossed off the list. Each phase below has its own bar driven by a deliverable checklist. Everything starts at 0%; update it as work lands.

How to update
=============

1. Flip a deliverable from ``[ ]`` to ``[x]`` when it ships.
2. Recompute that phase bar: ``percent = round(100 * checked / total)``.
3. Redraw the bar: ``filled_cells = round(percent / 5)`` out of 20 cells. Fill with ``█``, pad the rest with ``░`` (see the cell table below).
4. When a phase hits 100%, wrap its heading in ``:strike:`...``` and change its marker to ``[x] ✓ DONE``. That is the "crossed off" state.
5. Recompute the overall bar: ``overall = sum(phase_weight * phase_percent)`` using the weights in the checkpoint ruler. Any checkpoint whose threshold the overall bar has passed gets crossed off in the ruler.

Cell reference (20-cell bar, each cell = 5%)::

   0%  [░░░░░░░░░░░░░░░░░░░░]      55% [███████████░░░░░░░░░]
   5%  [█░░░░░░░░░░░░░░░░░░░]      60% [████████████░░░░░░░░]
   10% [██░░░░░░░░░░░░░░░░░░]      65% [█████████████░░░░░░░]
   15% [███░░░░░░░░░░░░░░░░░]      70% [██████████████░░░░░░]
   20% [████░░░░░░░░░░░░░░░░]      75% [███████████████░░░░░]
   25% [█████░░░░░░░░░░░░░░░]      80% [████████████████░░░░]
   30% [██████░░░░░░░░░░░░░░]      85% [█████████████████░░░]
   35% [███████░░░░░░░░░░░░░]      90% [██████████████████░░]
   40% [████████░░░░░░░░░░░░]      95% [███████████████████░]
   45% [█████████░░░░░░░░░░░]      100%[████████████████████]
   50% [██████████░░░░░░░░░░]

Legend (the three states a milestone moves through)::

   [ ] Not started     [░░░░░░░░░░░░░░░░░░░░]   0%
   [~] In progress     [██████████░░░░░░░░░░]  50%
   [x] ✓ DONE          [████████████████████] 100%   <- heading gets crossed off

Overall Project Progress
========================

::

   [░░░░░░░░░░░░░░░░░░░░] 0%

Checkpoint ruler. The overall bar is weighted by each phase's month estimate (phase months / 17). A checkpoint is crossed off once the overall bar passes its cumulative threshold.

- [ ] Phase 1: Foundation      weight 17.6%   cross off at   17.6%
- [ ] Phase 2: GUI Engine       weight 23.5%   cross off at   41.2%
- [ ] Phase 3: Guild Topology   weight 17.6%   cross off at   58.8%
- [ ] Phase 4: Customization    weight 17.6%   cross off at   76.5%
- [ ] Phase 5: Beta Testing     weight 11.8%   cross off at   88.2%
- [ ] Phase 6: Governance       weight 11.8%   cross off at  100.0%

Phase 1: Foundation
===================

**[ ] Phase 1: Foundation** — 3 Months

::

   [░░░░░░░░░░░░░░░░░░░░] 0%  (0 / 6 deliverables)

- [ ] IPFS/Openmesh main-node deployment (infra)
- [ ] Network Independence / Serverless via IPFS (spec §2)
- [ ] Access Through Name Only (spec §2)
- [ ] Individualized Key-Codes (spec §2)
- [ ] Secure Digital Handshake / SDH (spec §2)
- [ ] Dedicated E2EE Subsystem (spec §2)

Phase 2: GUI Engine
===================

**[ ] Phase 2: GUI Engine** — 4 Months

::

   [░░░░░░░░░░░░░░░░░░░░] 0%  (0 / 15 deliverables)

- [ ] Web Client Model (spec §1)
- [ ] 2.5D GUI (spec §1)
- [ ] Interactable 2.5D Objects (spec §1)
- [ ] Adaptive Layout (spec §1)
- [ ] Subchat (spec §1)
- [ ] Homespace (spec §1)
- [ ] Collapsible User and Homespace/Subchat Lists (spec §1)
- [ ] User-Friendly Interface (spec §1)
- [ ] 2.5D Tabbed Interface Feature (spec §1)
- [ ] Responsive Tab Management (spec §1)
- [ ] Quick Access Toolbar (spec §1)
- [ ] Integration with 2.5D Video Display (spec §1)
- [ ] 2.5D Tabs (spec §1)
- [ ] Interactive Hover Effects (spec §1)
- [ ] Secure 2.5D GUI Alignment (spec §2)

Phase 3: Guild Topology
=======================

**[ ] Phase 3: Guild Topology** — 3 Months

::

   [░░░░░░░░░░░░░░░░░░░░] 0%  (0 / 11 deliverables)

- [ ] Inter-Socket Communication (spec §3)
- [ ] Self-Sufficiency (spec §3)
- [ ] Adaptability (spec §3)
- [ ] Self-Healing (spec §3)
- [ ] Scalability (spec §3)
- [ ] Auto-enabled Sockets (spec §3)
- [ ] Drag-and-Drop File Sharing (spec §1)
- [ ] Friend Request Option (spec §1)
- [ ] DM Group Chats (spec §1)
- [ ] Message Forwarding (spec §1)
- [ ] Private vs. Public Homespaces (spec §2)

Phase 4: Customization
======================

**[ ] Phase 4: Customization** — 3 Months

::

   [░░░░░░░░░░░░░░░░░░░░] 0%  (0 / 11 deliverables)

- [ ] No Third-Party Dependency Nor Monetization (spec §4)
- [ ] Self-Hosting Option (spec §4)
- [ ] Dynamic 2.5D Environment Customization (spec §4)
- [ ] Customizable UIs (spec §4)
- [ ] Theming and Personalization Options (spec §4)
- [ ] Integration with Homespace Themes (spec §4)
- [ ] Avatar Customization (spec §4)
- [ ] Customizable Tab Design (spec §4)
- [ ] Real-Time Translation Option (spec §4)
- [ ] Desktop Console Router (spec §2)
- [ ] Random URL Generation Functionality — initial implementation (spec §2)

Phase 5: Beta Testing
=====================

**[ ] Phase 5: Beta Testing** — 2 Months

::

   [░░░░░░░░░░░░░░░░░░░░] 0%  (0 / 5 deliverables)

- [ ] Closed Alpha (Internal) stress tests
- [ ] Darknet Sandbox Testing
- [ ] Cross-Browser Validation
- [ ] Automod Dry-Run (XGBoost threshold tuning)
- [ ] Bug Bounty Program

Phase 6: Governance & Launch
============================

**[ ] Phase 6: Governance & Launch** — 2 Months

::

   [░░░░░░░░░░░░░░░░░░░░] 0%  (0 / 9 deliverables)

- [ ] Freedom of Speech/Expression Policy (spec §5)
- [ ] ToS (spec §5)
- [ ] Automod bot (spec §5)
- [ ] Hybrid Expert System (spec §5)
- [ ] Random URL Functionality — final hardening (spec §2)
- [ ] Audit Trail Integration
- [ ] WAPP Hardening (auto-kill switch)
- [ ] Contextual Transformer Deployment
- [ ] Final Publicization

Worked example (reference only, delete when real data lands)
============================================================

This is what a partially-complete tracker looks like. Phase 1 done and crossed off, Phase 2 half done, the rest untouched. Overall bar = (100 * 0.176) + (50 * 0.235) = 29.4%.

::

   Overall: [██████░░░░░░░░░░░░░░░] 29%

Checkpoint ruler at 29.4%::

   [x] :strike:`Phase 1: Foundation`      passed 17.6%
   [ ] Phase 2: GUI Engine                 next at 41.2%
   [ ] Phase 3 ... Phase 6                  pending

Phase headings in that state::

   [x] ✓ DONE  :strike:`Phase 1: Foundation`   [████████████████████] 100% (6 / 6)
   [~]         Phase 2: GUI Engine              [██████████░░░░░░░░░░]  50% (8 / 15)
