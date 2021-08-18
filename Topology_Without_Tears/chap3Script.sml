open HolKernel Parse boolLib bossLib;
open topologyTheory pred_setTheory
open chap2_2Theory;

val _ = new_theory "chap3";

(* 3.1.1 Definition *)
Theorem limpt_thm:
	∀t x A.
		limpt t x A ⇔
		∀U. open_in t U ∧ x ∈ U ⇒ ∃y. y ∈ U ∧ y ∈ A ∧ y ≠ x
Proof
	rw[limpt, neigh, PULL_EXISTS] >> EQ_TAC >>
	rw[] >> fs[IN_DEF]
	>- metis_tac[SUBSET_REFL]
	>> metis_tac[SUBSET_DEF, IN_DEF]
QED

Theorem example_3_1_3:
	∀A X.
		A ⊆ X ⇒ ∀x. x ∈ X ⇒ ¬limpt (discrete_topology X) x A
Proof
	rw[limpt_thm] >> qexists_tac `{x}` >> rw[]
QED

(* skipped example 3.1.4: it talks about real numbers *)

Theorem example_3_1_5:
	A ⊆ X ∧ u ∈ A ∧ A ≠ {u} ⇒
	∀x. x ∈ X ⇒ limpt (indiscrete_topology X) x A
Proof
	rw[limpt_thm] >> fs[] >>
	Cases_on `u = x` >> rw[]
	>- (`∃y. y ∈ A ∧ y ≠ u`
			suffices_by metis_tac[SUBSET_DEF] >>
		CCONTR_TAC >> fs[] >>
		qpat_x_assum `A ≠ {u}` mp_tac >> simp[] >>
		rw[EXTENSION] >> metis_tac[])
	>> metis_tac[SUBSET_DEF]
QED

Theorem prop_3_1_6:
	A ⊆ topspace t ⇒ (closed_in t A ⇔ ∀x. limpt t x A ∧ x ∈ (topspace t) ⇒ x ∈ A)
Proof
	rw[closed_in, limpt_thm] >> EQ_TAC >> rw[]
	>- (CCONTR_TAC >>
		first_x_assum drule >> rw[] >>
		metis_tac[])
	>> `∀x.
			x ∉ A ∧ x ∈ topspace t ⇒
			∃U. open_in t U ∧ x ∈ U ∧ (∀y. y ∈ U ∧ y ≠ x ⇒ y ∉ A)`
				by metis_tac[] >>
	gs[SKOLEM_THM, GSYM RIGHT_EXISTS_IMP_THM] >>
	`topspace t DIFF A = BIGUNION {f x | x ∉ A ∧ x ∈ topspace t}`
		by (rw[Once EXTENSION, PULL_EXISTS] >> EQ_TAC
			>- metis_tac[]
			>> rw[]
			>- (first_x_assum drule_all >> rw[] >>
				metis_tac[OPEN_IN_SUBSET, SUBSET_DEF])
			>> metis_tac[]) >>
	simp[] >> irule OPEN_IN_BIGUNION >>
	rw[] >> metis_tac[]
QED

val _ = export_theory();
