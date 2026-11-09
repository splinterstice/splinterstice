​=====================
Splinterstice Roadmap
=====================
 
:Date of Publication: 01/03/2026
:Project Status: Active Development
:Target Environment: Tor (.onion) and I2P (eepsite)
:Specification Reference: ``specs.md``
 
This roadmap is kept in one-to-one correspondence with ``splinterstice-specs.md``. Every one of the 46 feature items in the specification maps to exactly one delivery phase. Section 7 (Specification Traceability) is the audit matrix; if a spec item is added or removed, update that matrix and the affected phase in the same edit.
 
1. Project Roles and Governance
===============================
 
To ensure the successful delivery of Splinterstice as a decentralized, 2.5D hidden service, the following organizational structure is established:
 
- **General Project Manager (GPM) & Head Developer:** Lead architect and final authority for the Splinterstice codebase. Responsible for architectural oversight of the 2.5D engine and Ruby on Rails API, security auditing of E2EE subsystems, core backend development (socket clustering/IPFS), and release management of the master branch on Openmesh.
- **Project Organizer:** Operational lead assisting the GPM. Responsible for documentation management (spec/roadmap), community relations on Tor/I2P directories and social platforms, coordinating human-review escalations for the Hybrid Expert System, and administrative task tracking.
- **Open-Source Development Team:** A decentralized group of contributors.
 
  - **Frontend:** JavaScript/CSS depth-effect implementation and adaptive layout management.
  - **Backend/DevOps:** Docker/Kubernetes orchestration, Redis caching, and MySQL schema maintenance.
  - **Security:** E2EE refinement, Tor/I2P tunnel optimization, and WAPP hardening.
  - **Plugin Devs:** Development of interactable 2.5D objects and multimedia preview handlers.
 
2. Risks
========
 
.. list-table::
   :header-rows: 1
   :widths: 18 28 27 27
 
   * - Title
     - Description
     - Impact
     - Mitigation
   * - **Latency Jitter**
     - High latency inherent in Tor/I2P routing networks.
     - High: Real-time 2.5D interactions and socket stability may degrade.
     - Implement client-side interpolation for animations and aggressive Redis-backed ephemeral storage.
   * - **Data Persistence**
     - IPFS files may become "unpinned" if backup nodes are insufficient.
     - Medium: User-shared media or Homespace data could be lost.
     - Utilize the "Backup Node" system across multiple free-tier cloud services to ensure redundancy.
   * - **ToS False Positives**
     - Hybrid Expert System flags edge-case discourse as illegal.
     - Medium: Unauthorized service cutoff for law-abiding users.
     - Use XGBoost classifiers with high thresholds (>0.85); escalate 0.3-0.7 cases to human review.
   * - **De-anonymization**
     - Potential leaks at the exit-node level or via metadata.
     - Critical: Compromise of user privacy and platform security.
     - Use the dedicated E2EE subsystem to hide exit nodes and regenerate numerical URLs on every tab switch.
 
3. Assumptions
==============
 
- **AS-01:** Users possess a basic understanding of darknet navigation, including Tor Browser and I2P tunnel configurations.
- **AS-02:** Openmesh provides sufficient uptime and bandwidth for the primary node deployment through IPFS.
- **AS-03:** The community will provide sufficient hardware for self-hosting individual Homespaces to ensure true decentralization.
- **AS-04:** Modern browsers used in darknets support the necessary JavaScript ES6+ features and CSS depth effects required for 2.5D rendering.
 
4. Issues
=========
 
.. list-table::
   :header-rows: 1
   :widths: 18 28 15 39
 
   * - Title
     - Description
     - Priority
     - Resolution
   * - **Mobile Perf.**
     - 2.5D engine performance on low-end mobile devices is sub-optimal.
     - Medium
     - Implement an "Adaptive Layout" engine that scales visual depth based on hardware.
   * - **URL Refresh**
     - Random URL generation creates excessive page-refresh overhead.
     - Low
     - Optimize the state-management logic to update numerical strings without full DOM reloads.
   * - **Hash Overhead**
     - PhotoDNA hashing requires significant backend processing power.
     - High
     - Distribute hashing tasks across the socket cluster to prevent main-node bottlenecks.
 
5. Dependencies
===============
 
- **Openmesh Infrastructure:** Required for the decentralized deployment of the main node.
- **IPFS Protocol:** The primary "middleman" for backend-to-node connectivity and file storage.
- **Ruby on Rails 7.x:** The core framework for the Splinterstice API and DB network management.
- **MySQL & Redis:** Required for the dual-layer persistent (user data) and ephemeral (chat data) network.
- **Docker & Kubernetes:** Necessary for the automated orchestration of socket clusters and network scalability.
 
6. Milestones
=============
 
Summary of the six delivery phases. Per-phase deliverables, enumerated against the specification, follow in sections 6.1 through 6.6.
 
.. list-table::
   :header-rows: 1
   :widths: 30 50 20
 
   * - Phase
     - Deliverable
     - Estimate
   * - **Phase 1: Foundation**
     - Deployment of IPFS/Openmesh nodes, implementation of SDH protocol, and E2EE subsystem for Key-Codes.
     - 3 Months
   * - **Phase 2: GUI Engine**
     - 2.5D visualization core, Guild/Homespace architecture, and 2.5D tabbed interface with depth effects.
     - 4 Months
   * - **Phase 3: Guild Topology**
     - Auto-socket clustering, WebSocket/REST standardization, and DM/Group chat infrastructure.
     - 3 Months
   * - **Phase 4: Customization**
     - Mass UI customization toolkit, 2.5D Avatar system, Desktop WAPP (Console Router), and Translation engine.
     - 3 Months
   * - **Phase 5: Beta Testing**
     - Closed Alpha stress tests, Darknet Sandbox testing, Cross-browser validation, and Automod/XGBoost dry-runs.
     - 2 Months
   * - **Phase 6: Governance**
     - Activation of Hybrid Expert System, Random URL hardening, Audit Trail integration, and Final Publicization.
     - 2 Months
 
6.1 Phase 1: Foundation (3 Months)
----------------------------------
 
Security and access foundation. Delivers the specification's encryption and serverless-access layer so that every later phase builds on a working identity and deployment substrate.
 
Spec deliverables:
 
- **Network Independence / Serverless via IPFS** (spec §2) — deploy Openmesh main node and IPFS backup-node mesh.
- **Access Through Name Only** (spec §2) — Tor/I2P-only discoverability, no clearnet index.
- **Individualized Key-Codes** (spec §2) — cryptowallet-style per-account access codes issued at registration.
- **Secure Digital Handshake (SDH)** (spec §2) — encrypted-signature identity verification plus the animated 2.5D handshake confirmation.
- **Dedicated E2EE Subsystem** (spec §2) — server-side subsystem executing key-codes and hiding exit nodes and user IPs.
 
Infrastructure: IPFS/Openmesh node deployment (dependency, section 5).
 
6.2 Phase 2: GUI Engine (4 Months)
----------------------------------
 
The 2.5D front-end and Homespace shell. Delivers the full spec §1 interface set plus the security-alignment constraint from §2.
 
Spec deliverables:
 
- **Web Client Model** (spec §1)
- **2.5D GUI** (spec §1)
- **Interactable 2.5D Objects** (spec §1)
- **Adaptive Layout** (spec §1)
- **Subchat** (spec §1)
- **Homespace** (spec §1)
- **Collapsible User and Homespace/Subchat Lists** (spec §1)
- **User-Friendly Interface** (spec §1)
- **2.5D Tabbed Interface Feature** (spec §1)
- **Responsive Tab Management** (spec §1)
- **Quick Access Toolbar** (spec §1)
- **Integration with 2.5D Video Display** (spec §1)
- **2.5D Tabs** (spec §1)
- **Interactive Hover Effects** (spec §1)
- **Secure 2.5D GUI Alignment** (spec §2) — ensures the 2.5D layer never compromises data or communication integrity.
 
6.3 Phase 3: Guild Topology (3 Months)
--------------------------------------
 
The distributed socket fabric and messaging layer. Delivers all of spec §3, the §1 messaging features that ride on the socket fabric, and the §2 homespace privacy controls that depend on it.
 
Spec deliverables:
 
- **Inter-Socket Communication** (spec §3)
- **Self-Sufficiency** (spec §3)
- **Adaptability** (spec §3)
- **Self-Healing** (spec §3)
- **Scalability** (spec §3)
- **Auto-enabled Sockets** (spec §3) — per-homespace socket cluster auto-generated on creation.
- **Drag-and-Drop File Sharing** (spec §1)
- **Friend Request Option** (spec §1)
- **DM Group Chats** (spec §1) — max 10 participants.
- **Message Forwarding** (spec §1)
- **Private vs. Public Homespaces** (spec §2) — per-homespace and per-media visibility controls.
 
6.4 Phase 4: Customization (3 Months)
-------------------------------------
 
User-facing personalization, self-hosting, and the desktop access client. Delivers all of spec §4, plus the §2 Desktop Console Router and the initial implementation of Random URL generation.
 
Spec deliverables:
 
- **No Third-Party Dependency Nor Monetization** (spec §4)
- **Self-Hosting Option** (spec §4) — per-homespace self-host on user hardware, Matrix/XMPP-homeserver style.
- **Dynamic 2.5D Environment Customization** (spec §4)
- **Customizable UIs** (spec §4)
- **Theming and Personalization Options** (spec §4)
- **Integration with Homespace Themes** (spec §4)
- **Avatar Customization** (spec §4) — 2.5D avatar system.
- **Customizable Tab Design** (spec §4)
- **Real-Time Translation Option** (spec §4)
- **Desktop Console Router** (spec §2) — WAPP background router storing the key-code for browser access.
- **Random URL Generation Functionality** (spec §2) — initial implementation of per-tab-switch URL regeneration. Final hardening lands in Phase 6.
 
6.5 Phase 5: Beta Testing (2 Months)
------------------------------------
 
Validation of all prior phases. Introduces no new spec features; it exercises the ones already built and tunes the moderation pipeline before activation.
 
Deliverables:
 
- **Closed Alpha (Internal):** GPM and dev team stress-testing the 2.5D engine on a local IPFS cluster to identify rendering bottlenecks.
- **Darknet Sandbox Testing:** Private .onion link to select community testers to evaluate Tor-specific latency during peak usage.
- **Cross-Browser Validation:** Testing the web client on Tor Browser, I2P-Chromium, and standard browsers routed through the Desktop WAPP.
- **Automod Dry-Run:** Testing the Hybrid Expert System against known hash sets (PhotoDNA) in a controlled environment to tune XGBoost thresholds.
- **Bug Bounty Program:** Inviting open-source contributors to identify vulnerabilities in the E2EE subsystem and key-code generation logic.
 
6.6 Phase 6: Governance & Launch (2 Months)
-------------------------------------------
 
Activation of the compliance layer and public launch. Delivers all of spec §5, plus the final hardening of Random URL generation and the launch-support infrastructure.
 
Spec deliverables:
 
- **Freedom of Speech/Expression Policy** (spec §5) — absolutist posture bounded only by the ToS.
- **ToS** (spec §5) — the enforceable prohibited-conduct list.
- **Automod bot** (spec §5) — automatic service cutoff plus IPFS violation report for forwarding to authorities.
- **Hybrid Expert System** (spec §5) — full deployment of the CNN/XGBoost ToS-enforcement backend with PhotoDNA hashing and age estimation.
 
Supporting deliverables:
 
- **Random URL Functionality — final hardening** (spec §2) — harden numerical-URL regeneration against link-sharing and unauthorized access.
- **Audit Trail Integration** — IPFS-based violation-report system for forwarding illegal-activity reports to local authorities.
- **WAPP Hardening** — final Desktop Console Router release with an auto-kill switch for compromised local sessions.
- **Contextual Transformer Deployment** — transformer-based intent analysis for ambiguous ToS cases (0.3-0.7 confidence).
- **Final Publicization** — official release of platform addresses on Tor and I2P directories and network-independence verification.
 
7. Specification Traceability
=============================
 
Complete one-to-one map from every ``splinterstice-specs.md`` item to its delivery phase. 46 spec items, each assigned to exactly one phase. Random URL Generation is the only item spanning two phases (implementation in Phase 4, hardening in Phase 6) and is annotated as such.
 
.. list-table::
   :header-rows: 1
   :widths: 10 45 15 15
 
   * - Spec §
     - Spec Item
     - Phase
     - Estimate
   * - 1
     - Web Client Model
     - Phase 2
     - 4 Months
   * - 1
     - 2.5D GUI
     - Phase 2
     - 4 Months
   * - 1
     - Interactable 2.5D Objects
     - Phase 2
     - 4 Months
   * - 1
     - Adaptive Layout
     - Phase 2
     - 4 Months
   * - 1
     - Subchat
     - Phase 2
     - 4 Months
   * - 1
     - Homespace
     - Phase 2
     - 4 Months
   * - 1
     - Collapsible User and Homespace/Subchat Lists
     - Phase 2
     - 4 Months
   * - 1
     - Drag-and-Drop File Sharing
     - Phase 3
     - 3 Months
   * - 1
     - Friend Request Option
     - Phase 3
     - 3 Months
   * - 1
     - DM Group Chats
     - Phase 3
     - 3 Months
   * - 1
     - Message Forwarding
     - Phase 3
     - 3 Months
   * - 1
     - User-Friendly Interface
     - Phase 2
     - 4 Months
   * - 1
     - 2.5D Tabbed Interface Feature
     - Phase 2
     - 4 Months
   * - 1
     - Responsive Tab Management
     - Phase 2
     - 4 Months
   * - 1
     - Quick Access Toolbar
     - Phase 2
     - 4 Months
   * - 1
     - Integration with 2.5D Video Display
     - Phase 2
     - 4 Months
   * - 1
     - 2.5D Tabs
     - Phase 2
     - 4 Months
   * - 1
     - Interactive Hover Effects
     - Phase 2
     - 4 Months
   * - 2
     - Random URL Generation Functionality
     - Phase 4 (impl) / Phase 6 (harden)
     - 3 + 2 Months
   * - 2
     - Access Through Name Only
     - Phase 1
     - 3 Months
   * - 2
     - Individualized Key-Codes
     - Phase 1
     - 3 Months
   * - 2
     - Secure Digital Handshake (SDH)
     - Phase 1
     - 3 Months
   * - 2
     - Dedicated E2EE Subsystem
     - Phase 1
     - 3 Months
   * - 2
     - Secure 2.5D GUI Alignment
     - Phase 2
     - 4 Months
   * - 2
     - Private vs. Public Homespaces
     - Phase 3
     - 3 Months
   * - 2
     - Network Independence/Serverless via IPFS
     - Phase 1
     - 3 Months
   * - 2
     - Desktop Console Router
     - Phase 4
     - 3 Months
   * - 3
     - Inter-Socket Communication
     - Phase 3
     - 3 Months
   * - 3
     - Self-Sufficiency
     - Phase 3
     - 3 Months
   * - 3
     - Adaptability
     - Phase 3
     - 3 Months
   * - 3
     - Self-Healing
     - Phase 3
     - 3 Months
   * - 3
     - Scalability
     - Phase 3
     - 3 Months
   * - 3
     - Auto-enabled Sockets
     - Phase 3
     - 3 Months
   * - 4
     - No Third-Party Dependency Nor Monetization
     - Phase 4
     - 3 Months
   * - 4
     - Self-Hosting Option
     - Phase 4
     - 3 Months
   * - 4
     - Dynamic 2.5D Environment Customization
     - Phase 4
     - 3 Months
   * - 4
     - Customizable UIs
     - Phase 4
     - 3 Months
   * - 4
     - Theming and Personalization Options
     - Phase 4
     - 3 Months
   * - 4
     - Integration with Homespace Themes
     - Phase 4
     - 3 Months
   * - 4
     - Avatar Customization
     - Phase 4
     - 3 Months
   * - 4
     - Customizable Tab Design
     - Phase 4
     - 3 Months
   * - 4
     - Real-Time Translation Option
     - Phase 4
     - 3 Months
   * - 5
     - Freedom of Speech/Expression Policy
     - Phase 6
     - 2 Months
   * - 5
     - ToS
     - Phase 6
     - 2 Months
   * - 5
     - Automod bot
     - Phase 6
     - 2 Months
   * - 5
     - Hybrid Expert System
     - Phase 6
     - 2 Months
 
[Notes on Estimates]
====================
 
Estimates are based on current open-source contributor velocity. The decentralized nature of the socket clusters and IPFS integration may introduce variability in testing timelines. Milestones are subject to shift based on the results of the Phase 5 Darknet Sandbox testing. Total nominal schedule across the six phases is 17 months. Live phase progress is tracked in ``milestones.rst``.
