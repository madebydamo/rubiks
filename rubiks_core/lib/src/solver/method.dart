import '../model/position.dart';
import 'algorithms/algorithm_set.dart';
import 'builder.dart';

/* SolverBuilder roux = SolverBuilder.start() */
/*     .solvePieces( */
/*         edges: [EdgePosition.LD, EdgePosition.LB, EdgePosition.LF], */
/*         corners: [CornerPosition.LDF, CornerPosition.LDB], */
/*         depth: 6, */
/*         allowedMoves: ["f", "b", "r", "l", "u", "d", "m"]) */
/*     .solvePieces( */
/*         edges: [EdgePosition.RD, EdgePosition.RB, EdgePosition.RF], */
/*         corners: [CornerPosition.RDF, CornerPosition.RDB], */
/*         depth: 6, */
/*         allowedMoves: ["f", "b", "r", "l", "u", "d", "m"]) */
/*     .solveAlgo(CMLL) */
/*     .solvePieces(edges: [ */
/*   EdgePosition.LU, */
/*   EdgePosition.RU, */
/*   EdgePosition.UF, */
/*   EdgePosition.UB, */
/*   EdgePosition.DF, */
/*   EdgePosition.DB, */
/* ], depth: 13, allowedMoves: ["u", "m"]); */

SolverBuilder roux2 = SolverBuilder.start()
    .solvePieces(
        edges: [EdgePosition.LD],
        depth: 3,
        allowedMoves: ["f", "b", "r", "l", "u", "d", "m"])
    .solvePieces(
        edges: [EdgePosition.LF],
        corners: [CornerPosition.LDF],
        depth: 4,
        allowedMoves: ["f", "r", "l", "u", "d", "m"],
        allowedPremoves: ["f", "b", "r", "u", "m"])
    .solvePieces(
        edges: [EdgePosition.LB],
        corners: [CornerPosition.LDB],
        depth: 4,
        allowedMoves: ["b", "r", "l", "u", "d", "m"],
        allowedPremoves: ["b", "r", "u", "m"])
    .solvePieces(
        edges: [EdgePosition.RD, EdgePosition.RB],
        corners: [CornerPosition.RDB],
        depth: 5,
        allowedMoves: ["b", "r", "l", "u", "d", "m"],
        allowedPremoves: ["r", "u", "m"])
    .solvePieces(
        edges: [EdgePosition.RF],
        corners: [CornerPosition.RDF],
        depth: 4,
        allowedMoves: ["f", "r", "l", "u", "d", "m"],
        allowedPremoves: ["u", "m"])
    .solveAlgo(CMLL)
    .solvePieces(
        edges: [
          EdgePosition.LU,
          EdgePosition.RU,
          EdgePosition.UF,
          EdgePosition.UB,
          EdgePosition.DF,
          EdgePosition.DB,
        ],
        depth: 13,
        allowedMoves: ["u", "m"])
    .finish();


