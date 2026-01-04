**Splinterstice Roadmap**

   | **Date of Publication:** 01/03/2026​
   | **Project Status:** Active Development​
   | **Target Environment:** Tor (.onion) and I2P (eepsite)

   1. Project Roles and Governance

   To ensure the successful delivery of Splinterstice as a
   decentralized, 2.5D hidden service, the following organizational
   structure is established:

   | ●​ **General Project Manager (GMP) & Head Developer:** Lead
     architect and final authority for the Splinterstice codebase.
     Responsible for architectural oversight of the 2.5D engine and Ruby
     on Rails API, security auditing of E2EE subsystems, core backend
   | development (socket clustering/IPFS), and release management of the
     master branch on Openmesh.

   ●​ **Project Organizer:** Operational lead assisting the GMP.
   Responsible for documentation management (spec/roadmap), community
   relations on Tor/I2P directories and social platforms, coordinating
   human-review escalations for the Hybrid Expert System, and
   administrative task tracking.

   ●​ **Open-Source Development Team:** A decentralized group of
   contributors.

   ○​ **Frontend:** JavaScript/CSS depth effect implementation and
   adaptive layout management.

   ○​ **Backend/DevOps:** Docker/Kubernetes orchestration, Redis caching,
   and MySQL schema maintenance.

   ○​ **Security:** E2EE refinement, Tor/I2P tunnel optimization, and
   WAPP hardening.

   ○​ **Plugin Devs:** Development of interactable 2.5D objects and
   multimedia preview handlers.

   2. Risks

+-----------------+-----------------+-----------------+-----------------+
|    **Title**    |                 |    **Impact**   |                 |
|                 | **Description** |                 |  **Mitigation** |
+=================+=================+=================+=================+
|    **Latency    |    | High       |    | High:      |    | Implement  |
|    Jitter**     |      latency    |      Real-time  |                 |
|                 |      inherent   |      2.5D       |     client-side |
|                 |      in Tor/I2P |                 |                 |
|                 |      routing    |    interactions |   interpolation |
|                 |    | networks.  |      and        |      for        |
|                 |                 |    | socket     |    | animations |
|                 |                 |      stability  |      and        |
|                 |                 |      may        |    | aggressive |
|                 |                 |      degrade.   |                 |
|                 |                 |                 |  | Redis-backed |
|                 |                 |                 |    | ephemeral  |
|                 |                 |                 |      storage.   |
+-----------------+-----------------+-----------------+-----------------+
|    **Data       |    | IPFS files |    Medium:      |    | Utilize    |
|                 |      may        |    User-shared  |      the        |
|   Persistence** |    | become     |    media or     |      "Backup    |
|                 |      "unpinned" |    Homespace    |    | Node"      |
|                 |      if backup  |    data could   |      system     |
|                 |      nodes are  |    be lost.     |      across     |
|                 |                 |                 |      multiple   |
|                 | | insufficient. |                 |      free-tier  |
|                 |                 |                 |    | cloud      |
|                 |                 |                 |      services   |
|                 |                 |                 |      to         |
|                 |                 |                 |    | ensure     |
|                 |                 |                 |                 |
|                 |                 |                 |     redundancy. |
+-----------------+-----------------+-----------------+-----------------+
|    **ToS False  |    | Hybrid     |    | Medium:    |    | Use        |
|    Positives**  |      Expert     |                 |      XGBoost    |
|                 |      System     |  | Unauthorized |                 |
|                 |      flags      |      service    |   | classifiers |
|                 |      edge-case  |      cutoff for |      with high  |
|                 |    | discourse  |                 |      thresholds |
|                 |      as         |     law-abiding |      (>0.85);   |
|                 |      illegal.   |      users.     |      escalate   |
|                 |                 |                 |      0.3-0.7    |
|                 |                 |                 |    | cases to   |
|                 |                 |                 |      human      |
|                 |                 |                 |    | review.    |
+-----------------+-----------------+-----------------+-----------------+
|    **De-        |    Potential    |    Critical:    |    | Use        |
| anonymization** |    leaks at the |    Compromise   |      Dedicated  |
|                 |    exit node    |    of user      |      E2EE       |
|                 |    level or via |    privacy and  |      Subsystem  |
|                 |    metadata.    |    platform     |      to hide    |
|                 |                 |    security.    |    | exit nodes |
|                 |                 |                 |      and        |
|                 |                 |                 |    | regenerate |
|                 |                 |                 |      numerical  |
|                 |                 |                 |      URLs on    |
|                 |                 |                 |      every tab  |
|                 |                 |                 |    | switch.    |
+-----------------+-----------------+-----------------+-----------------+

..

   3. Assumptions

   ●​ **AS-01:** Users possess a basic understanding of darknet
   navigation, including Tor Browser and I2P tunnel configurations.

   ●​ **AS-02:** Openmesh provides sufficient uptime and bandwidth for
   the primary node deployment through IPFS.

   ●​ **AS-03:** The community will provide sufficient hardware for
   self-hosting individual Homespaces to ensure true decentralization.

   ●​ **AS-04:** Modern browsers used in darknets support the necessary
   JavaScript ES6+ features and CSS depth effects required for 2.5D
   rendering.

   4. Issues

+-----------------+-----------------+-----------------+-----------------+
|    **Title**    |                 |    **Priority** |                 |
|                 | **Description** |                 |  **Resolution** |
+=================+=================+=================+=================+
|    **Mobile     |    | 2.5D       |    Medium       |    | Implement  |
|    Perf.**      |      engine     |                 |      an         |
|                 |                 |                 |    | "Adaptive  |
|                 |   | performance |                 |      Layout"    |
|                 |      on low-end |                 |      engine     |
|                 |      mobile     |                 |      that       |
|                 |      devices is |                 |      scales     |
|                 |                 |                 |      visual     |
|                 |  | sub-optimal. |                 |      depth      |
|                 |                 |                 |      based on   |
|                 |                 |                 |      hardware.  |
+-----------------+-----------------+-----------------+-----------------+
|    **URL        |    | Random URL |    Low          |    | Optimize   |
|    Refresh**    |    | Generation |                 |      the        |
|                 |      creates    |                 |    | s          |
|                 |      excessive  |                 | tate-management |
|                 |      page       |                 |      logic to   |
|                 |    | refresh    |                 |      update     |
|                 |      overhead.  |                 |    | numerical  |
|                 |                 |                 |      strings    |
|                 |                 |                 |      without    |
|                 |                 |                 |      full DOM   |
|                 |                 |                 |    | reloads.   |
+-----------------+-----------------+-----------------+-----------------+
|    **Hash       |    PhotoDNA     |    High         |    | Distribute |
|    Overhead**   |    hashing      |                 |      hashing    |
|                 |    requires     |                 |      tasks      |
|                 |    significant  |                 |      across the |
|                 |    backend      |                 |    | socket     |
|                 |    processing   |                 |      cluster to |
|                 |    power.       |                 |    | prevent    |
|                 |                 |                 |      main node  |
|                 |                 |                 |                 |
|                 |                 |                 |    bottlenecks. |
+-----------------+-----------------+-----------------+-----------------+

..

   5. Dependencies

   ●​ **Openmesh Infrastructure:** Required for the decentralized
   deployment of the main node.

   ●​ **IPFS Protocol:** The primary "middleman" for backend-to-node
   connectivity and file storage.

   ●​ **Ruby on Rails 7.x:** The core framework for the Splinterstice API
   and DB Network management.

   ●​ **MySQL & Redis:** Required for the dual-layer persistent (user
   data) and ephemeral (chat data) network.

   ●​ **Docker & Kubernetes:** Necessary for the automated orchestration
   of socket clusters and network scalability.

   6. Milestones

+-----------------------+-----------------------+-----------------------+
|    **Phase**          |    **Deliverable**    |    **Estimate**       |
+=======================+=======================+=======================+
|    **Phase 1:         |    | Deployment of    |    3 Months           |
|    Foundation**       |    | IPFS/Openmesh    |                       |
|                       |      nodes,           |                       |
|                       |      implementation   |                       |
|                       |      of SDH           |                       |
+-----------------------+-----------------------+-----------------------+

+-----------------------+-----------------------+-----------------------+
|    **Phase**          |    **Deliverable**    |    **Estimate**       |
+=======================+=======================+=======================+
|                       |    | protocol, and    |                       |
|                       |      E2EE             |                       |
|                       |    | subsystem for    |                       |
|                       |      Key-Codes.       |                       |
+-----------------------+-----------------------+-----------------------+
|    **Phase 2: GUI     |    | 2.5D             |    4 Months           |
|    Engine**           |      visualization    |                       |
|                       |      core,            |                       |
|                       |    | Guild/Homespace  |                       |
|                       |    | architecture,    |                       |
|                       |      and 2.5D tabbed  |                       |
|                       |      interface with   |                       |
|                       |      depth effects.   |                       |
+-----------------------+-----------------------+-----------------------+
|    **Phase 3: Guild   |    | Auto-socket      |    3 Months           |
|    Topology**         |      clustering,      |                       |
|                       |    | WebSocket/REST   |                       |
|                       |    | standardization, |                       |
|                       |      and              |                       |
|                       |    | DM/Group chat    |                       |
|                       |      infrastructure.  |                       |
+-----------------------+-----------------------+-----------------------+
|    **Phase 4:         |    Mass UI            |    3 Months           |
|    Customization**    |    customization      |                       |
|                       |    toolkit, 2.5D      |                       |
|                       |    Avatar system,     |                       |
|                       |    Desktop WAPP       |                       |
|                       |    (Console Router),  |                       |
|                       |    and Translation    |                       |
|                       |    engine.            |                       |
+-----------------------+-----------------------+-----------------------+
|    **Phase 5: Beta    |    | Closed Alpha     |    2 Months           |
|    Testing**          |      stress tests,    |                       |
|                       |    | Darknet Sandbox  |                       |
|                       |      testing,         |                       |
|                       |    | Cross-browser    |                       |
|                       |      validation, and  |                       |
|                       |      Automod/XGBoost  |                       |
|                       |      dry-runs.        |                       |
+-----------------------+-----------------------+-----------------------+
|    **Phase 6:         |    | Activation of    |    2 Months           |
|    Governance**       |      Hybrid Expert    |                       |
|                       |      System, Random   |                       |
|                       |      URL              |                       |
|                       |    | hardening, Audit |                       |
|                       |      Trail            |                       |
|                       |    | integration, and |                       |
|                       |      Final            |                       |
|                       |    | Publicization.   |                       |
+-----------------------+-----------------------+-----------------------+

..

   6.1 Phase 5 Detailed Entry: Web Client Beta Testing

   ●​ **Closed Alpha (Internal):** GMP and Dev team stress-testing the
   2.5D engine on a local IPFS cluster to identify rendering
   bottlenecks.

   ●​ **Darknet Sandbox Testing:** Opening a private .onion link to
   select community testers to evaluate Tor-specific latency during peak
   usage.

   ●​ **Cross-Browser Validation:** Testing the web client on Tor
   Browser, I2P-Chromium, and standard browsers routed through the
   Desktop WAPP.

   ●​ **Automod Dry-Run:** Testing the Hybrid Expert System against known
   hash sets (PhotoDNA) in a controlled environment to tune XGBoost
   thresholds.

   ●​ **Bug Bounty Program:** Inviting open-source contributors to
   identify vulnerabilities in the E2EE subsystem and key-code
   generation logic.

   6.2 Phase 6 Detailed Entry: Final Governance & Launch

   ●​ **Hybrid Expert System Activation:** Full deployment of the
   CNN/XGBoost ToS enforcement bot with PhotoDNA hashing and age
   estimation.

   ●​ **Random URL Functionality:** Final hardening of the numerical URL
   regeneration feature to prevent link-sharing and unauthorized access.

   ●​ **Audit Trail Integration:** Implementation of the IPFS-based
   violation report system for forwarding illegal activity reports to
   local authorities.

   ●​ **WAPP Hardening:** Final release of the Desktop Console Router
   with an auto-kill switch for compromised local sessions.

   ●​ **Contextual Transformer Deployment:** Activation of the
   transformer-based intent analysis for ambiguous ToS cases (0.3-0.7
   confidence).

   ●​ **Final Publicization:** Official release of platform addresses on
   Tor and I2P directories and network independence verification.

   7. Notes on Estimates

   Estimates are based on current open-source contributor velocity. The
   decentralized nature of the socket clusters and IPFS integration may
   introduce variability in testing timelines. Milestones are subject to
   shift based on the results of the Phase 5 Darknet Sandbox testing.​
